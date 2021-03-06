# encoding: UTF-8
# Copyright © 2012, 2013, 2014, 2015, Carousel Apps

require "bigdecimal"
require "net/http"
require "net/https"
require "json"
require "uri"

# Nexmo response
class ActionTexter::NexmoResponse < ActionTexter::Response
  SUCCESS_RESPONSE_CODE = "0"

  # TODO: Some of these should be moved to Response if they are common enough.
  attr_reader :original, :parts_count, :parts, :cost, :remaining_balance, :reference

  private

  def process_response(raw)
    @success = true
    @original = JSON.parse(raw)
    @parts_count = @original["message-count"].to_i
    @cost = BigDecimal.new("0")
    @reference = @original["messages"].first["client-ref"] # They should all be the same, we only record it the first time.
    @remaining_balance = @original["messages"].last["remaining-balance"] # I hope the last one is the lowest one, the cost of a single message shouldn't make that big of a difference anyway.
    @parts = []
    error_messages = []
    @original["messages"].each do |raw_part|
      if @success # Update the contents of success to status of this part unless @succes is already failed.
        @success = raw_part["status"] == SUCCESS_RESPONSE_CODE
      end
      part = {:id => raw_part["message-id"],
              :to => raw_part["to"],
              :success => raw_part["status"] == SUCCESS_RESPONSE_CODE}
      part[:reference] = raw_part["client-ref"] if raw_part.has_key? "client-ref"
      if raw_part.has_key? "message-price"
        part[:cost] = raw_part["message-price"]
        @cost += BigDecimal.new(raw_part["message-price"])
      end
      if raw_part.has_key? "remaining-balance"
        part[:remaining_balance] = BigDecimal.new(raw_part["remaining-balance"])
      end
      if raw_part.has_key? "error-text"
        part[:error_message] = raw_part["error-text"]
        error_messages << part[:error_message]
      end
      @parts << part
    end
    if error_messages.any?
      @error_message = error_messages.uniq.join(", ")
    end
  end
end

# Implementation of client for Nexmo: http://nexmo.com
class ActionTexter::NexmoClient < ActionTexter::Client
  attr_accessor :key, :secret

  # Create a new Nexmo client with key and secret.
  #
  # @param [String] key key as specified by Nexmo for authenticating.
  # @param [String] secret secret as specified by Nexmo for authenticating.
  def initialize(key, secret)
    super()
    self.key = key
    self.secret = secret
  end

  def deliver(message)
    client = Net::HTTP.new("rest.nexmo.com", 443)
    client.use_ssl = true

    # Nexmo doesn't like phone numbers starting with a +
    # Pattern only matches phones that are pristine phone numbers starting with a +, and leaves everything else alone
    pattern = /^\+(\d+)$/
    from = (message.from =~ pattern ? message.from.gsub(pattern, '\1')  : message.from )
    to = (message.to =~ pattern ? message.to.gsub(pattern, '\1')  : message.to )

    response = client.post(
        "/sms/json",
        URI.encode_www_form("username" => @key,
                            "password" => @secret,
                            "from" => from,
                            "to" => to,
                            "text" => message.text,
                            "type" => (message.text.ascii_only? ? "text" : "unicode"),
                            "client-ref" => message.reference),
        {"Content-Type" => "application/x-www-form-urlencoded"})

    return ActionTexter::NexmoResponse.new(response.body)
  end

  # @private
  def to_s
    "#<#{self.class.name}:#{key}>"
  end
end
