# frozen_string_literal: true

require_relative "config.rb" unless defined? Config

require "sinatra"
require "haml"

require_relative "lib/rabbit_mq.rb"
require_relative "lib/publisher.rb"

class App < Sinatra::Application
  configure do
    set :root,          Config.root
    set :server,        :puma
    set :rabbit,        RabbitMQ.new
    # set :public_folder, Config.root + "/public"
  end

  get "/" do
    haml :index
  end

  get "/publish" do
    haml :publish
  end

  post "/publish" do
    @publisher ||= Publisher.new(settings.rabbit)
    result = @publisher.publish(params["message"])

    if result[:success]
      haml :publish, locals: { success: result[:message] }
    else
      haml :publish, locals: { failure: result[:message] }
    end
  end
end
