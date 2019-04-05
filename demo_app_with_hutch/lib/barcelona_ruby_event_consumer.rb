# frozen_string_literal: true

class BarcelonaRubyEventConsumer
  include Hutch::Consumer

  arguments "x-dead-letter-exchange" => "#{Hutch::Config.mq_exchange}_dlx"
  consume "barcelona.ruby.event"
  queue_name "barcelona_ruby_event"

  def process(message)
    print "#{self.class.get_queue_name}: #{message.routing_key}: "
    ap message.body[:message]
  end
end
