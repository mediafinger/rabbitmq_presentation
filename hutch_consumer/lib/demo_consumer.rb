class DemoConsumer
  include Hutch::Consumer
  consume 'hutch.demo.*'
  arguments "x-dead-letter-exchange" => "#{Hutch::Config.mq_exchange}_dlx"

  # optional
  # queue_name 'demo_consumer'

  def process(message)
    print "Demo: "
    raise("REJECTED")
  end
end
