# frozen_string_literal: true

# Require this file when starting the Hutch consumer process with
# bundle exec hutch --require hutch_consumer_config.rb

require "awesome_print"
require "hutch"

load "./hutch_shared_config.rb"

#
# Require all consumers
#
# * this will create all queues
# * this will bind the queues to the given binding_keys
# * the consumers will start consuming
#
Dir[File.join(".", "lib", "**", "*.rb")].sort.each { |file| require file }

Hutch.connect unless ENV["RACK_ENV"] == "test"

# print config variables for development
ap Hutch::Config

#
# Error handling setup, call after Hutch.connect
#
# * dead-letter-exchange receives messages that fail while processing (nack/reject)
#

# Setup dead-letter-exchange and queue that catches all messages
dlx = create_exchange(name: "#{Hutch::Config.mq_exchange}_dlx")
create_queue(name: "dlx__all__failures")
bind_queue(name: "dlx__all__failures", exchange: dlx, routing_key: "#")

# Setup dead-letter exchange queues for each 'normal' queue with same routing_keys
# individual_queues(consumers: Hutch.consumers, exchange: dlx, prefix: "dlx")
