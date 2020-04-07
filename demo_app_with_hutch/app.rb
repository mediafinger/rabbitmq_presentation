# frozen_string_literal: true

require_relative "settings.rb" unless defined? Settings

# Hutch.connect - create queues and start consuming
load "./hutch_publisher_config.rb" unless ENV["RACK_ENV"] == "test"

class Client
  def self.publish(routing_keys:, message:, properties: {}, options: {})
    raise("message has to be a hash") unless message.is_a?(Hash)

    Hutch.publish(routing_keys, message, properties, options)
  end
end
