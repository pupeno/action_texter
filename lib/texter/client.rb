# Copyright © 2012, 2013, Watu

# Parent class for all SMS clients.
#
# @abstract
class Texter::Client
  def self.default
    @default
  end

  def self.default=(client)
    @default = client
  end

  def self.setup(provider, *attrs)
    provider_client =
        begin
          Texter.const_get(provider + "Client")
        rescue NameError
          raise "Provider #{provider} doesn't exist."
        end
    self.default = provider_client.new(*attrs)
  end

  # Deliver a message
  # @param [Message] message message to be delivered
  # @returns [Response] a response
  def deliver(message)
    raise NotImplementedError.new("should be implemented by subclasses")
  end

  # @private
  def to_s
    "#<#{self.class.name}:#{object_id}>"
  end
end
