# frozen_string_literal: true

require "bunny"

class RabbitMQ
  def initialize
    bind("handle_it", "topic_exchange", "#") # bind queue to all routing_keys
  end

  def connection
    return @connection unless @connection.nil?

    connection = Bunny.new(Config.rabbit_url)
    connection.start

    @connection = connection
  end

  def channel
    return @channel unless @channel.nil?

    channel = connection.create_channel
    channel.confirm_select # activate Publisher Confirms

    @channel = channel
  end

  def exchange(name, options: { type: :topic })
    @exchange ||= channel.exchange(name, options)
  end

  def queue(name, auto_delete: false, durable: false)
    @queue ||= channel.queue(name, auto_delete: auto_delete, durable: durable)
  end

  def bind(queue_name, exchange_name, routing_key)
    queue(queue_name).bind(exchange(exchange_name), routing_key: routing_key)
  end
end
