module Api
  class Call

    def initialize(auth)
      @provider = auth.provider
      @access_token = auth.token
      @merchant_id = auth.merchant_id
    end

    def items
      if @provider == "clover"
        @items = Api::Clover.new(@access_token, @merchant_id).items
      else
        items = 'FAIL'
      end
    end

    def sync_items
      @items.each do |item|
         i = Item.find_or_create_by(item_id: item.id)
         i.name = item.name
         i.save
      end
    end
  end
end
