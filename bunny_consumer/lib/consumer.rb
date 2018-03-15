# frozen_string_literal: true

class Consumer
  def initialize(rabbit, queue_name)
    @rabbit = rabbit
    @queue_name = queue_name
  end

  def status
    "#{consumer.consumer_tag} ready to consume #{@queue_name} which has #{@rabbit.queue(@queue_name).message_count} messages."
  end

  def subscribe
    consumer.queue.subscribe_with(consumer)
  end

  def pause
    @rabbit.channel.basic_cancel(consumer.consumer_tag)
  end

  private

  def consumer
    return @consumer unless @consumer.nil?

    consumer = Bunny::Consumer.new(@rabbit.channel, @rabbit.queue(@queue_name), @rabbit.channel.generate_consumer_tag, false) # false = no_ack == manual_ack
    process_queue(consumer)

    @consumer = consumer
  end

  def process_queue(consumer)
    consumer.on_delivery do |delivery_info, properties, payload|
      puts "* * * * * * * *"

      if payload.length < 3
        sleep(4)
        puts "Message length shorter 3, message REJECTED"
        @rabbit.channel.nack(delivery_info.delivery_tag, false, false) # only one message, do not requeue
      else
        puts "ID: #{properties.message_id} -- #{properties.timestamp}"
        puts ""
        puts payload
        puts ""
        sleep(4)
        @rabbit.channel.ack(delivery_info.delivery_tag)
      end
    end
  end
end
