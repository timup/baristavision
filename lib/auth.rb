require 'Clover'
require 'Square'

class Auth

  def self.sync_merchant_items
    if current_user.authentication.provider == "square"
      merchant_items = Square.new(current_user.authentication.token).merchant_items
    elsif current_user.authentication.provider == "clover"
      merchant_items = Clover.new("#{current_user.access_token}", "#{current_user.merchant_id}").merchant_items
    end

    merchant_items.each do |item|
      i = Item.find_or_initialize_by(name: item['name'])
      i.name = item['name']
      i.save
    end
  end

end
