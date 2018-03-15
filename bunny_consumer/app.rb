# frozen_string_literal: true

require_relative "config.rb" unless defined? Config

require "sinatra"
require "haml"

require_relative "lib/rabbit_mq.rb"
require_relative "lib/consumer.rb"

class App < Sinatra::Application
  configure do
    set :root,          Config.root
    set :server,        :puma
    set :rabbit,        RabbitMQ.new
    # set :public_folder, Config.root + "/public"
  end

  get "/" do
    @consumer ||= Consumer.new(settings.rabbit, "handle_it")
    @status = @consumer.status
    @consumer.subscribe

    # TODO: display stream of consumed messages

    haml :index
  end
end
