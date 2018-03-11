# frozen_string_literal: true

class Publisher
  def initialize(rabbit)
    @rabbit = rabbit
  end

  def publish(message)
    return { success: false, message: "Message expected" } if message.nil? || message.empty?

    result = send_message(message)

    if result[:success]
      { success: true, message: "Processed published message queue has now #{@rabbit.queue('handle_it').message_count} messages." }
    else
      { success: false, message: "That did not work, the following messages have been nack'ed: #{result[:error]}" }
    end
  end

  private

  def send_message(message)
    @rabbit.exchange("topic_exchange").publish(
      message,
      routing_key: "barcelona.on.rails",
      message_id:  @rabbit.channel.next_publish_seq_no,
      timestamp:   Time.now.utc.to_i,
    )

    success = @rabbit.channel.wait_for_confirms # Publisher Confirms extension

    hash = {}
    hash["error"] = @rabbit.channel.nacked_set unless success
    hash["ok"] = true if success

    { success: hash["ok"], error: hash["error"] }
  end
end
