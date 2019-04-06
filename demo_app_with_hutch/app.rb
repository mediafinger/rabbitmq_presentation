# frozen_string_literal: true

require_relative "settings.rb" unless defined? Settings

require "sinatra"
require "haml"

# Hutch.connect - create queues and start consuming
load "./hutch_publisher_config.rb" unless ENV["RACK_ENV"] == "test"

class Client
  def self.publish(routing_keys:, message:, properties: {}, options: {})
    raise("message has to be a hash") unless message.is_a?(Hash)

    Hutch.publish(routing_keys, message, properties, options)
  end
end

class App < Sinatra::Application
  configure do
    set :root,          Settings.root
    set :server,        :puma
  end

  get "/" do
    haml :index
  end

  get "/publish" do
    haml :publish
  end

  post "/publish" do
    routing_keys = params.fetch("routing_keys", "barcelona.ruby.event")
    message      = { message: params["message"] }

    # Publish message:
    result = Client.publish(routing_keys: routing_keys, message: message)

    # For demonstration only:
    queue_name     = "barcelona_ruby_event"
    queue          = result.channel.queues.find { |name, _q| name == queue_name }&.last
    messages_count = queue&.message_count || 0

    # TODO: check for success
    haml :publish, locals: { success: "Queue #{queue_name} has now #{messages_count} messages." }

  # TODO: rescue other possible errors
  rescue ArgumentError => e
    haml :publish, locals: {
      failure: "Error: the following message has not been delivered: '#{params[:message]}' to #{routing_keys}. Error: #{e}",
    }
  end
end
