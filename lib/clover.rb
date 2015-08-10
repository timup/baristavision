class Clover
  include HTTParty # When you HTTParty, you must party hard.
  base_uri 'api.clover.com:443'

  def initialize(access_token, merchant_id)
    @auth = {access_token: access_token}
    @merchant_id = merchant_id
  end

  def items
    options = { query: @auth }
    self.class.get("/v3/merchants/#{@merchant_id}/items", options)
  end

  def item(item_id)
    options = { query: @auth }
    self.class.get("/v3/merchants/#{@merchant_id}/items/#{item_id}", options)
  end

  def orders
    options = { query: @auth }
    self.class.get("/v3/merchants/#{@merchant_id}/orders", options)
  end

  def order(order_id)
    options = { query: @auth }
    self.class.get("/v3/merchants/#{@merchant_id}/orders/#{order_id}", options)
  end

  def close_order(order_id)
    # original thought was modify order "state"...BV intention is mod attribute "printed"...should exist as boolean
    #
    # original call
    # --------------------------
    # options = { :body => {:state => 'CLOSED'}.to_json, query: @auth, :headers => { 'Content-Type' => 'application/json' } }
    # self.class.post("/v3/merchants/#{@merchant_id}/orders/#{order_id}")
  end

  def line_items(order_id)
    options = { query: @auth }
    self.class.get("/v3/merchants/#{@merchant_id}/orders/#{order_id}/line_items", options)
  end

  # Below to help dev only

  def new_order(order_title)
    options = { :body =>  {:title => order_title, :state => 'OPEN'}.to_json, query: @auth, :headers => { 'Content-Type' => 'application/json' } }
    self.class.post("/v3/merchants/#{@merchant_id}/orders", options)
  end
end

# @clover.orders()
# @clover.close_order(order_id)
# @clover.items
# @clover.item(item_id)
