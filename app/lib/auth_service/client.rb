require 'dry-initializer'
require_relative 'api'

module AuthService
  class Client
    include Api

    def initialize
      @channel = RabbitMq.channel
      @exchange = channel.default_exchange
      @server_queue_name = 'auth'

      @lock = Mutex.new
      @condition = ConditionVariable.new

      setup_reply_queue
    end

    def publish(payload, opts = {})
      @exchange.publish(payload,
        opts.merge(routing_key: 'auth',
                   correlation_id: @correlation_id,
                   reply_to: @reply_queue.name))

      @lock.synchronize { @condition.wait(lock) }

      @response
    end


    private

    attr_writer :response, :correlation_id

    def setup_reply_queue
      self.correlation_id = SecureRandom.uuid
      @reply_queue = @channel.queue('', exclusive: true)

      @reply_queue.subscribe do |_delivery_info, properties, payload|
        if properties[:correlation_id].eql?(@correlation_id)
          self.response = JSON(payload)['user_id']

          @lock.synchronize { @condition.signal }
        end
      end
    end

  end
end
