# encoding: UTF-8
# Copyright © 2012, 2013, 2014, 2015, Carousel Apps

require "bigdecimal"

# Responses sent by #TestClient
class ActionTexter::TestResponse < ActionTexter::Response
  attr_reader :parts_count, :parts, :cost, :remaining_balance, :reference, :error

  private

  def process_response(raw)
    cost_per_message = BigDecimal("0.058")
    @success = true
    @original = raw
    @reference = @original.reference if !@original.reference.nil?
    @remaining_balance = BigDecimal.new("15.10")
    @cost = BigDecimal.new("0")
    @parts = []
    (@original.text.length.to_f / 140).ceil.times do
      @remaining_balance = @remaining_balance - cost_per_message
      part = {:id => "test-response-#{Time.now.to_i}",
              :to => @original.to,
              :remaining_balance => @remaining_balance,
              :cost => cost_per_message,
              :success => true}
      part[:reference] = @original.reference if !@original.reference.nil?
      @cost += part[:cost]
      @parts << part
    end
    @parts_count = @parts.count
  end
end

# A client that doesn't send any message but instead stores them on an array.
class ActionTexter::TestClient < ActionTexter::Client
  def initialize
    @@deliveries = []
  end

  def deliver(message)
    @@deliveries << message
    ActionTexter::TestResponse.new(message)
  end

  # All the delivered messages so far.
  #
  # @return [Array<Message>] delivered messages.
  def deliveries
    @@deliveries
  end
end
