class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items, dependent: :destroy

  after_create :notify_order_added

  class << self
    def on_change
      Order.connection.execute "LISTEN orders"
      loop do
        Order.connection.raw_connection.wait_for_notify do |event, pid, order|
          return order
        end
      end
    ensure
      Order.connection.execute "UNLISTEN orders"
    end
  end

  private

  def notify_order_added
    Order.connection.execute "NOTIFY orders, '#{self.id}'"
  end

end
