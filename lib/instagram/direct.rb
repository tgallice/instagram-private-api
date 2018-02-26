module Instagram
  module Direct
    def self.send_like(user, recipients)
      JSON.parse Instagram::API.post_request(
        user,
        'direct_v2/threads/broadcast/like/',
        {
          recipient_users: [recipients],
          action: 'send_item',
        }
      ).body
    end

    def self.send_message(user, recipients, text)
      JSON.parse Instagram::API.post_request(
        user,
        'direct_v2/threads/broadcast/text/',
        {
          text: text,
          recipient_users: [recipients],
          action: 'send_item',
        }
      ).body
    end

    def self.get_thread(user, thread_id, cursor_id = nil)
      path = "direct_v2/threads/#{thread_id}/?use_unified_inbox=true"

      if cursor_id
        path += "&cursor=#{cursor_id}"
      end

      JSON.parse Instagram::API.get_request(user, path).body
    end

    def self.get_inbox(user, cursor_id = nil)
      path = "direct_v2/inbox/?persistentBadging=true&use_unified_inbox=true"

      if cursor_id
        path += "&cursor=#{cursor_id}"
      end

      JSON.parse  Instagram::API.get_request(user, path).body
    end
  end
end
