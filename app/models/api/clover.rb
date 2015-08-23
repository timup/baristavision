module Api
  class Clover

    include HTTParty

    base_uri Api::Config.clover_url

    def initialize(access_token, merchant_id)
      @access_token = access_token
      @merchant_id = merchant_id
    end

    def line_items(order_id)
      response = query({
        :endpoint => "/v3/merchants/#{@merchant_id}/orders/#{order_id}/line_items",
        :method => :GET,
        :params => {
          :access_token => @access_token
        }
        })
      response = response.elements
    end

    def order(order_id)
      response = query({
        :endpoint => "/v3/merchants/#{@merchant_id}/orders/#{order_id}",
        :method => :GET,
        :params => {
          :access_token => @access_token
        }
        })
    end

    def orders
      response = query({
        :endpoint => "/v3/merchants/#{@merchant_id}/orders",
        :method => :GET,
        :params => {
          :access_token => @access_token
          }
        })
        response = response.elements
      # returns an array of order hashes
    end

    def items
      response = query({
      :endpoint => "/v3/merchants/#{@merchant_id}/items",
      :method => :GET,
      :params => {
        :access_token => @access_token
        }
      })
      response = response.elements
      # returns an array of item hashes
    end

    def query opts
      method   = opts[:method].to_s.downcase
      options  = {query: opts[:params],
                  headers: opts[:headers],
                  body: opts[:body]}
      response = self.class.send(method, opts[:endpoint], options)
      data     = response.parsed_response

      if response.success?
        if [ TrueClass, FalseClass, Fixnum ].include?(data.class)
          data
        else
          convert_to_mash(data)
        end
      else
        nil
      end
    end

    # ------------------------------- #
    # methods for clover testing
    # ------------------------------- #
    def test_add_line_item(order_id)
      items = Item.all
      response = query({
        :endpoint => "/v3/merchants/#{@merchant_id}/orders/#{order_id}/line_items",
        :method => :POST,
        :params => {
          :access_token => @access_token
        },
        :headers => {
          'Content-Type' => 'application/json'
        },
        :body => {
          :item => {
            :id => "#{items.shuffle.first.item_id}"
            }
        }.to_json
        })
    end

    def test_add_order
      response = query({
        :endpoint => "/v3/merchants/#{@merchant_id}/orders",
        :method => :POST,
        :params => {
          :access_token => @access_token
        },
        :headers => {
          'Content-Type' => 'application/json'
        },
        :body => {
          :title => "Order - #{Time.now}",
          :state => "OPEN"
        }.to_json
        })
    end

    def test_delete_order(order_id)
      response = query({
        :endpoint => "/v3/merchants/#{@merchant_id}/items",
        :method => :GET,
        :params => {
          :access_token => @access_token
          }
        })
    end

    private

    def convert_to_mash data
      if data.is_a? Hash
        Hashie::Mash.new(data)
      elsif data.is_a Array
        data.map { |d| Hashie::Mash.new(d) }
      end
    end

  end
end
