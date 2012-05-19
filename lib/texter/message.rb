# Copyright © 2012, Watu

# Representation of a message
#
# TODO: Implement these fields that Nexmo can use: :status_report_req, :network_code, :vcard, :vcal, :ttl
#
# @!attribute from
#   @return [String] name or phone number of the author of the message.
# @!attribute to
#   @return [String] phone number of the author of the message.
# @!attribute text
#   @return [String] actual message to send.
# @!attribute reference
#   @return [String] a reference that can be used later on to track responses. Implemented for: Nexmo.
class Texter::Message
  attr_accessor :from, :to, :text, :reference

  def initialize(message = {})
    self.from = message[:from] || raise("A message must contain from")
    self.to = message[:to] || raise("A message must contain to")
    self.text = message[:text] || raise("A message must contain text")
    self.reference = message[:reference]
  end

  def deliver(client = nil)
    client ||= Texter::Client.default
    if client.nil?
      raise "To deliver a message you need to specify a client by parameter to deliver or by Texter::Client.dafault="
    end
    client.deliver(self)
  end

  # @private
  def to_s
    "#<#{self.class.name}:#{from}:#{to}:#{text}>"
  end
end
