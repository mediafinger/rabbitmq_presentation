# frozen_string_literal: true

require_relative "app.rb"

require "sinatra"
require "haml"

class Server < Sinatra::Application
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
