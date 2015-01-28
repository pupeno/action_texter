# encoding: UTF-8
# Copyright © 2014, 2015, Carousel Apps

module ActionTexter
  @@delivery_observers = []
  @@delivery_interceptors = []

  # You can register an object to be informed of every SMS that is sent, after it is sent
  # Your object needs to respond to a single method #delivered_sms(message, response)
  #    message will be of type ActionTexter::Message
  #    response will be of type ActionTexter::Response
  #
  # @param observer [Object] with a #delivered_sms method that will be called passing in the ActionTexter::Message
  #   and ActionTexter::Response
  # @returns the observer added
  def self.register_observer(observer)
    unless @@delivery_observers.include?(observer)
      @@delivery_observers << observer
    end
    observer
  end

  # Unregister the given observer
  #
  # @param observer [Object] to unregister
  # @returns deleted observer
  def self.unregister_observer(observer)
    @@delivery_observers.delete(observer)
  end

  # You can register an object to be given every Message object that will be sent, before it is sent.
  # This allows you to modify the contents of the message, or even stop it by returning false or nil.
  #
  # Your object needs to respond to a single method #delivering_sms(message)
  # It must return the modified object to be sent instead, or nil
  #
  # @param interceptor [Object] with a #delivering_sms method that will be called passing in the ActionTexter::Message
  # @returns the interceptor added
  def self.register_interceptor(interceptor)
    unless @@delivery_interceptors.include?(interceptor)
      @@delivery_interceptors << interceptor
    end
    interceptor
  end

  # Unregister the given interceptor
  #
  # @param interceptor [Object] to unregister
  # @returns deleted interceptor
  def self.unregister_interceptor(interceptor)
    @@delivery_interceptors.delete(interceptor)
  end

  # Inform all the observers about the SMS being sent
  #
  # @param message [ActionTexter::Message] that is being sent
  # @returns the list of observers
  def self.inform_observers(message, response)
    @@delivery_observers.each { |observer| observer.delivered_sms(message, response) }
  end


  # Inform all the interceptors about the SMS being sent. Any interceptor can modify the message or cancel it
  #
  # @param message [ActionTexter::Message] that is being sent
  # @returns the message that must be sent, returned by the last interceptor. This may be nil or false
  def self.inform_interceptors(message)
    @@delivery_interceptors.each do |interceptor|
      message = interceptor.delivering_sms(message)
      break if message.blank?
    end
    message
  end

end
