# frozen_string_literal: true

class BarcelonaRubyQuestionConsumer
  include Hutch::Consumer

  arguments "x-dead-letter-exchange" => "#{Hutch::Config.mq_exchange}_dlx"
  consume "barcelona.ruby.question"
  queue_name "barcelona_ruby_question"

  def process(message)
    puts "------------------------------"
    print "#{self.class.get_queue_name}: "
    ap message.body

    print "payload (body before deserialization): "
    ap message.payload

    print "properties: "
    ap message.properties

    print "delivery_info: "
    ap message.delivery_info
    puts "------------------------------"
  end
end
