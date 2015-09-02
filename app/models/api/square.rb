module Api
  class Square

    include HTTParty

    base_uri Api::Config.square_url

    def initialize(access_token)
      @access_token = access_token
    end

    # square 'itemizations'
    def line_items(order_id)
      response = query({
        :endpoint => "/v1/me/payments/#{order_id}",
        :method => :GET,
        :params => {
          :headers => {
            "Authorization" => "Bearer #{@access_token}",
            "Accept" => "application/json"
          }
        }
        })
        response = response.itemizations
    end

    # square 'payments'
    def orders
      response = query({
        :endpoint => "/v1/me/payments",
        :method => :GET,
        :params => {
          :default_params => {
            :order => "ASC"
          },
          :headers => {
             "Authorization" => "Bearer #{@access_token}",
             "Accept" => "application/json"
          }
        }
        })
    end

    # square 'items'
    def items
      response = query({
        :endpoint => "/v1/me/items",
        :method => :GET,
        :params => {
          :headers => {
             "Authorization" => "Bearer #{@access_token}",
             "Accept" => "application/json"
          }
        }
        })
    end

    def query opts
      method   = opts[:method].to_s.downcase
      response = self.class.send(method, opts[:endpoint], opts[:params])
      data     = response.parsed_response

      if response.success?
        if [ TrueClass, FalseClass, Fixnum ].include?(data.class)
          data
        else
          puts response.request.inspect
          convert_to_mash(data)
        end
      else
        nil
      end
    end

    # ------------------------------- #
    # methods for square testing
    # ------------------------------- #

    def delete_order(order_id)
      response = query({
        :endpoint => "/v1/me/payments/#{order_id}",
        :method => :DELETE,
        :params => {
          :headers => {
             "Authorization" => "Bearer #{@access_token}",
             "Accept" => "application/json"
          }
        }
        })

      if response.code == 200
        puts 'Successfully deleted item'
        return response.body
      else
        puts 'Item deletion failed'
        return nil
      end
    end

    private

    def convert_to_mash data
      if data.is_a? Hash
        Hashie::Mash.new(data)
      elsif data.is_a? Array
        data.map { |d| Hashie::Mash.new(d) }
      end
    end



  end
end
