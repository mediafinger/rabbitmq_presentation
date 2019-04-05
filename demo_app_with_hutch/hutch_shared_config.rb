# frozen_string_literal: true

# The config has to be the same for Publisher and Consumer
#
# Services that want to communicate with each other, all have to use the same config!

# defaults
# mq_username: guest
# mq_password: guest
# mq_host: 127.0.0.1
# uri nil
# enable_http_api_use true

# Set name of exchange, default is 'hutch'
Hutch::Config.set(:mq_exchange, "topix")

# Activate Publisher Confirms, default is false
Hutch::Config.set(:publisher_confirms, true)
# Do not use the alternative: force_publisher_confirms which forces Hutch::Broker#wait_for_confirms
# for every publish (blocking the thread). While it is the safest option it also offers the lowest throughput

# When a message can not be routed on the default exchange "topix"
# the publisher_confirms feature will nack / reject it
# instead of sending it back to the publisher, we re-route it
# to an alternate-exchange
# TODO: add this to hutch's README
Hutch::Config.set(:mq_exchange_options, arguments: { "alternate-exchange": "#{Hutch::Config.mq_exchange}_ae" })

# Set a QoS level / prefetch_count for the whole channel, default is 0 == all in the queue
# 1 is the safest and slowest setting
Hutch::Config.set(:channel_prefetch, 1)

# Custom logger
client_logger = Logger.new("log/bunny.log")
Hutch::Config.set(:client_logger, client_logger)
Hutch::Logging.logger = client_logger

# error_handlers: a list of error handler objects, see classes in Hutch::ErrorHandlers.
# All configured handlers will be invoked unconditionally in the order listed.
Hutch::Config.set(:error_handlers, [Hutch::ErrorHandlers::Logger.new])

# Set a namespace to generate unique queue names
# TODO: test this and add to hutch's README
# Hutch::Config.set(:namespace, "service_name")

# error_acknowledgements: a chain of responsibility of objects
# that acknowledge/reject/requeue messages when an exception happens
# see classes in Hutch::Acknowledgements
# e.g. we could:
# * requeue on failure
# * reject/nack == send to dead_letter_queue when message older than x hours
# * log to Sentry
# Hutch::Config.set(:error_acknowledgements, [])

#
# helper methods, used by consumer and publisher for our failure setup
# using bunny gem methods over Hutch.broker.channel
#
def create_exchange(name:, options: { type: :topic, durable: true, auto_delete: false })
  Hutch.broker.channel.exchange(name, options)
end

def create_queue(name:, options: { type: :topic, durable: true, auto_delete: false })
  Hutch.broker.channel.queue(name, options)
end

def bind_queue(name:, exchange:, routing_key:)
  Hutch.broker.channel.queue_bind(name, exchange, routing_key: routing_key)
end

def individual_queues(consumers:, exchange:, prefix:)
  consumers.each do |consumer|
    queue_name   = consumer.get_queue_name
    routing_keys = consumer.routing_keys

    create_queue(name: "#{prefix}__#{queue_name}")

    routing_keys.each do |routing_key|
      bind_queue(name: "#{prefix}__#{queue_name}", exchange: exchange, routing_key: routing_key)
    end
  end
end
