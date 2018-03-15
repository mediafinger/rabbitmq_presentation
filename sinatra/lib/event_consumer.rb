class EventConsumer
  include Hutch::Consumer
  consume 'hutch.demo.event', 'hutch.entity.event'
  arguments "x-dead-letter-exchange" => "#{Hutch::Config.mq_exchange}_dlx"

  # optional
  # queue_name 'event_consumer'

  def process(message)
    sleep(rand)
    print "Event: "
    ap message
  end
end
