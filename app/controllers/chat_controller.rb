class ChatController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      # Listen on its own thread
      redis_thread = Thread.new do
        # Needs its own redis connection to pub
        # and sub at the same time
        REDIS.subscribe params[:id] do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        # pub the message when we get one
        # note: this echoes through the sub above
        REDIS.publish m.split(",")[0], m.split(",")[1]
      end
      
      tubesock.onclose do
        # stop listening when client leaves
        redis_thread.kill
      end
    end
  end
end
