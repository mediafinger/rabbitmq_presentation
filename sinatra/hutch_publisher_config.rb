# Require this file when starting the service that will publish messages

require "awesome_print"
require "hutch"

load "./hutch_shared_config.rb"

Hutch.connect

# print config variables for development
ap Hutch::Config

#
# Error handling setup, call after Hutch.connect
#
# * alternate-exchange receives messages that can not be routed
#

# Setup alternate-exchange and queue that catches all messages
ae = create_exchange(name: "#{Hutch::Config.mq_exchange}_ae")
create_queue(name: "ae__all__unroutable")
bind_queue(name: "ae__all__unroutable", exchange: ae, routing_key: "#")

# Setup alternate exchange queues for each 'normal' queue with same routing_keys
# individual_queues(consumers: Hutch.consumers, exchange: ae, prefix: "ae")

#
# Example how to publish messages
#
# publish(routing_key: "hutch.demo.event", message: "A man, a plan, a canal panama!")

#
# helper method, calling Hutch.publish with some solaris default values
#
def publish(routing_key:, message:, properties: {}, options: {})
  raise("message has to be a hash") unless message.is_a?(Hash)

  default_properties = { correleation_id: "a_request_id" }
  props = default_properties.merge(properties)

  Hutch.publish(routing_key, message, props, options)
end

# Hutch's publish implementation
#
# * the default Serializer is JSON
#
# def publish(routing_key, message, properties = {}, options = {})
#   ensure_connection!(routing_key, message)
#
#   serializer = options[:serializer] || config[:serializer]
#
#   non_overridable_properties = {
#     routing_key:  routing_key,
#     timestamp:    connection.current_timestamp,
#     content_type: serializer.content_type,
#   }
#   properties[:message_id]   ||= generate_id
#
#   payload = serializer.encode(message)
#
#   log_publication(serializer, payload, routing_key)
#
#   response = exchange.publish(payload, {persistent: true}.
#     merge(properties).
#     merge(global_properties).
#     merge(non_overridable_properties))
#
#   channel.wait_for_confirms if config[:force_publisher_confirms]
#   response
# end
