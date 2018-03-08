require 'instagram/version'
require 'openssl'
require 'base64'
require 'digest/md5'
require 'net/http'
require 'json'
require 'instagram/user'
require 'instagram/account'
require 'instagram/feed'

module Instagram
  module API
    def self.compute_hash(data)
      OpenSSL::HMAC.hexdigest OpenSSL::Digest.new('sha256'), Constants::PRIVATE_KEY[:SIG_KEY], data
    end

    def self.generate_uuid
      'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.gsub(/[xy]/) do |c|
        r = (Random.rand * 16).round | 0
        v = c == 'x' ? r : (r & 0x3 | 0x8)
        c.gsub(c, v.to_s(16))
      end.downcase
    end

    def self.create_md5(data)
      Digest::MD5.hexdigest(data).to_s
    end

    def self.generate_device_id
      timestamp = Time.now.to_i.to_s
      'android-' + create_md5(timestamp)[0..16]
    end

    def self.generate_signature(data)
      data = data.to_json
      compute_hash(data) + '.' + Instagram::Utils.encode(data)
    end

    def self.http(args)
      args[:url] = URI.parse(args[:url])
      http = Net::HTTP.new(args[:url].host, args[:url].port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = nil
      if args[:method] == 'POST'
        request = Net::HTTP::Post.new(args[:url].path)
      elsif args[:method] == 'GET'
        request = Net::HTTP::Get.new(args[:url].path + (!args[:url].nil? ? '?' + args[:url].query : ''))
      end

      request.initialize_http_header(:'User-Agent' => args[:user].useragent,
                                     :Accept => Instagram::Constants::HEADER[:accept],
                                     :'Accept-Encoding' => Instagram::Constants::HEADER[:encoding],
                                     :'Accept-Language' => args[:user].language,
                                     :'X-IG-Capabilities' => Instagram::Constants::HEADER[:capabilities],
                                     :'X-IG-Connection-Type' => Instagram::Constants::HEADER[:type],
                                     :'X-IG-Connection-Speed' => "#{rand(5000)}kbps",
                                     :'X-FB-HTTP-Engine' => Instagram::Constants::FB_HTTP_ENGINE,
                                     :'Content-Type' => Instagram::Constants::HEADER[:content_type],
                                     :Cookie => (args[:user].session.nil? ? '' : args[:user].session))
      request.body = args.key?(:body) ? args[:body] : nil

      response = Instagram::Response.new(http.request(request))

      unless response.is_ok?
        Instagram::Exceptions.throw(response)
      end

      response
    end

    def self.get_request(user, path)
      Instagram::API.http(
        url: Constants::URL + path,
        method: 'GET',
        user: user
      )
    end

    def self.post_request(user, path, payload = {}, is_signed = false)
      body = payload.merge(
        {
          client_context: Instagram::API.generate_uuid,
          _csrftoken: user.csrf_token,
          _uuid: user.uuid
        }
      )

      if is_signed
        body = format(
          'ig_sig_key_version=4&signed_body=%s',
          Instagram::API.generate_signature(body)
        )
      else
        body = Instagram::Utils.hash_encode(body)
      end

      Instagram::API.http(
        url: Constants::URL + path,
        method: 'POST',
        user: user,
        body: body
      )
    end

    def self.generate_rank_token(pk)
      format('%s_%s', pk, Instagram::API.generate_uuid)
    end
  end
end
