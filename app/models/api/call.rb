module Api
  class Call

    attr_accessor :connect

    def initialize(auth)
      @authentication = auth
      @provider = auth.provider
      @access_token = auth.token
      @merchant_id = auth.merchant_id

      if @provider == "clover"
        @connect = Api::Clover.new(@access_token, @merchant_id)
      elsif @provider == "square"
        @connect = Api::Square.new(@access_token)
      end
    end

    def last_order
      order = Order.where(user_id: @authentication.user.id).last
    end

    # initialize api connection
    # def connect
    #   if @provider == "clover"
    #     connect = Api::Clover.new(@access_token, @merchant_id)
    #   elsif @provider == "square"
    #     connect = Api::Square.new()
    #   end
    # end

    # method to sync all merchant line items to line_items table
    def sync_line_items
      sync_items
      sync_orders
      orders = Order.where(user_id: @authentication.user.id)
      orders.each do |order|
        line_items = @connect.line_items(order.provider_order_id)
        api_line_item_ids = []
        if line_items.present?
          line_items.each_with_index do |line_item, index|
            if @provider == 'clover'
              li = LineItem.where(:provider_line_item_id => line_item.id).first_or_initialize
              i = Item.find_by(provider_item_id: line_item.item.id)
              li.line_item_id = line_item.id
              li.item_id = i.id
              li.order_id = order.id
              li.save!
              api_line_item_ids << line_item.id
            elsif @provider == 'square'
              li = LineItem.where(:provider_line_item_id => "#{order.provider_order_id}---#{index}").first_or_initialize
              i = Item.find_by(provider_item_id: line_item.item_detail.item_id)
              li.item_id = i.try(:id)
              li.order_id = order.id
              li.save!
              api_line_item_ids << line_item.id
            end
          end
        end

        user_line_items = []
        @user_order_ids.each do |order|
          LineItem.where(order_id: order).each do |line_item|
            user_line_items << line_item
          end
        end

        user_line_item_ids = []
        user_line_items.each do |line_item|
          user_line_item_ids << line_item.line_item_id
        end

        remove_ids = user_line_item_ids - api_line_item_ids
        remove_ids.each do |id|
          LineItem.where(provider_line_item_id: id).delete_all
        end

      end
    end

    # good to go: clover and square
    # method to sync all merchant orders to order table
    def sync_orders
      #orders array from api call
      orders = @connect.orders
    #  api_order_ids = []
      if orders
        orders.each do |order|
          o = Order.where(:provider_order_id => order.id).first_or_initialize
          o.user_id = @authentication.user.id
          o.save!
        #  api_order_ids << order.id
        end
      end

      # user_orders = Order.where(user_id: @authentication.user.id)
      # @user_order_ids = []
      # user_orders.each do |order|
      #   @user_order_ids << order.provider_order_id
      # end
      #
      # remove_ids = @user_order_ids - api_order_ids
      # remove_ids.each do |id|
      #   # first delete all line items associated with order
      #   # Order.where(order_id: id).each do |order|
      #   #   LineItem.where(order_id: order.order_id
      #   # end
      #   Order.where(provider_order_id: id).delete_all
      # end
    end

    # Good to go: clover & square
    # method to sync all merchant items to item table
    def sync_items
      # items array from api call
      items = @connect.items
      api_item_ids = []
      if items
        items.each do |item|
          # for each item update in db or create new instance
          i = Item.where(:provider_item_id => item.id).first_or_initialize
          i.name = item.name
          i.user_id = @authentication.user.id
          i.save!
          api_item_ids << item.id
        end
      end

      # get all item_ids from db for user
      user_items = Item.where(user_id: @authentication.user.id)
      user_items_ids = []
      user_items.each do |item|
        user_items_ids << item.provider_item_id
      end
      # set array with all ids to be removed
      remove_ids = user_items_ids - api_item_ids
      remove_ids.each do |id|
        Item.where(provder_item_id: id).delete_all
      end
    end


    # Previous version below

    def items
      if @provider == "clover"
        @items = Api::Clover.new(@access_token, @merchant_id).items
      else
        items = 'FAIL'
      end
    end

    # def sync_items
    #   @items.each do |item|
    #      i = Item.find_or_create_by(item_id: item.id)
    #      i.name = item.name
    #      i.save
    #   end
    # end
  end
end
