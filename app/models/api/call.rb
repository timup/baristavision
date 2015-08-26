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
      sync_orders
      orders = Order.where(user_id: @authentication.user.id)
      orders.each do |order|
        line_items = @connect.line_items(order.order_id)
        if line_items.present?
          line_items.each do |line_item|
            li = LineItem.where(:line_item_id => line_item.id).first_or_initialize
            i = Item.find_by(item_id: line_item.item.id)
            li.item_id = i.id
            li.order_id = order.id
            li.save!
          end
        end
      end
    end

    # method to sync all merchant orders to order table
    def sync_orders
      #orders array from api call
      orders = @connect.orders
      api_order_ids = []
      if orders
        orders.each do |order|
          o = Order.where(:order_id => order.id,
                          :user_id => @authentication.user.id).first_or_initialize
          o.user_id = @authentication.user.id
          o.save!
          api_order_ids << order.id
        end
      end

      user_orders = Order.where(user_id: @authentication.user.id)
      user_order_ids = []
      user_orders.each do |order|
        user_order_ids << order.order_id
      end

      remove_ids = user_order_ids - api_order_ids
      remove_ids.each do |id|
        Order.where(order_id: id).delete_all
      end
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
          i = Item.where(:item_id => item.id,
                         :name => item.name,
                         :user_id => @authentication.user.id).first_or_initialize
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
        user_items_ids << item.item_id
      end
      # set array with all ids to be removed
      remove_ids = user_items_ids - api_item_ids
      remove_ids.each do |id|
        Item.where(item_id: id).delete_all
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
