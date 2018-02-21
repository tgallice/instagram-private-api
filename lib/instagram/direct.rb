module Instagram
  module Direct
    def self.send_message(user, recipients, text)
      response = Instagram::API.http(
        url: Constants::URL + 'direct_v2/threads/broadcast/text/',
        method: 'POST',
        user: user,
        body: Instagram::Utils.hash_encode({
          recipient_users: [recipients],
          action: 'send_item',
          client_context: Instagram::API.generate_uuid,
          text: text,
          _csrftoken: user.csrf_token,
          _uuid: user.uuid
        })
      )

      JSON.parse response.body
    end
  end
end
