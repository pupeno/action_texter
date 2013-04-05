# encoding: UTF-8
# Copyright © 2012, 2013, Watu

# A response as sent from the provider.
#
# @abstract
# @!attribute [r] raw
#   @return [String] the raw response as returned by the provider
# @!attribute success
#   @return [Boolean] weather sending the message succeeded or not. See #success? and #failed?
# @!attribute error_message
#   @return [String] a descriptive message of the error when an error happened.
class Texter::Response
  attr_reader :raw, :success, :error_message

  def initialize(raw)
    @raw = raw
    process_response(raw)
  end

  # @return [Boolean] true when sending the message succeeded, false otherwise.
  def success?
    !!@success
  end

  # @return [Boolean] false when sending the message failed, true otherwise.
  def failed?
    !@success
  end

  # @private
  def to_s
    "#<#{self.class.name}:#{object_id}:#{@success ? "success" : "fail"}>"
  end

  private

  def process_response(raw)
    raise NotImplementedError.new("should be implemented by subclasses")
  end
end
