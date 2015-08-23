module Api
  class Call

    def initialize(auth)
      @authentication = auth
      @provider = auth.provider
      @access_token = auth.token
      @merchant_id = auth.merchant_id

      if @provider == "clover"
        @connect = Api::Clover.new(@access_token, @merchant_id)
      elsif @provider == "square"
        @connect = Api::Square.new()
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

    # method to sync all merchant orders to order table
    def self.sync_orders
      response = @connect.orders
      if response
        orders = response
        orders.each do |order|
          order = Order.find_or_create_by(order_id: order.order_id)
          order.save!
        end
      end
    end

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
      remove_ids.each do |remove|
        Item.where(item_id: remove).delete_all
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
