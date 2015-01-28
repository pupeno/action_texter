# encoding: UTF-8
# Copyright © 2014, 2015, Carousel Apps

require "bigdecimal"
require "net/http"
require "net/https"
require "json"
require "uri"

# Twilio response
class ActionTexter::TwilioResponse < ActionTexter::Response
  # TODO: Some of these should be moved to Response if they are common enough.
  attr_reader :original, :parts_count, :cost, :reference

  private

  def process_response(raw)
    @original = JSON.parse(raw)

    if @original["error_code"].blank? && @original["code"].blank?
      @success = true
      @reference = @original["sid"]
      @parts_count = @original["num_segments"]

      # The cost is nil because the message is, as of now, queued. To get the cost we need to GET @original["uri"]
      # for message details, but that assumes that the message is sent by that time.
      # The proper way, a callback, is way out of the scope of this gem.
      @cost = nil
    else
      @success = false

      # Responses take two shapes. Either they have a status like "queued", and they have an "error_code" field
      #    (which I've never seen filled), or they return a status like "400", with a "code" and a "message"
      if @original.has_key?("code")
        @error_message = @original["message"]
      elsif @original.has_key?("error_message")
        @error_message = @original["error_message"]
      end
    end
  end
end

# Implementation of client for Twilio: http://twilio.com
class ActionTexter::TwilioClient < ActionTexter::Client
  attr_accessor :account_sid, :auth_token

  # Create a new Twilio client with account sid and auth token
  #
  # @param [String] account_sid as specified by Twilio for authenticating.
  # @param [String] auth_token as specified by Twilio for authenticating.
  def initialize(account_sid, auth_token)
    super()
    self.account_sid = account_sid
    self.auth_token = auth_token
  end

  def deliver(message)
    http = Net::HTTP.new("api.twilio.com", 443)
    http.use_ssl = true
    request = Net::HTTP::Post.new("/2010-04-01/Accounts/#{@account_sid}/Messages.json")
    request.basic_auth(@account_sid, @auth_token)
    request.set_form_data({"From" => message.from, "To" => message.to, "Body" => message.text})
    response = http.request(request)

    return ActionTexter::TwilioResponse.new(response.body)
  end

  # @private
  def to_s
    "#<#{self.class.name}:#{key}>"
  end
end
