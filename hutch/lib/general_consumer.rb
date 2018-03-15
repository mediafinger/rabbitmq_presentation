class GeneralConsumer
  include Hutch::Consumer
  consume 'hutch.#'
  arguments "x-dead-letter-exchange" => "#{Hutch::Config.mq_exchange}_dlx"

  # optional
  # queue_name 'general_consumer'

  def process(message)
    sleep(rand)
    print "General: "
    raise "REJECTED" if rand < 0.2
    ap message
  end
end
