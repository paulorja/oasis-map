module Gameplay
  class GlobalChat < GameplayCmd

    def run
      if params['chat_message'].is_a? String
        server.channel_push('all', ClientMessages.global_chat({
          nickname: player.character.nickname,
          chat_message: params['chat_message']
        }))
      end
    end

  end
end
