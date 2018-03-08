module Instagram
  class Response
    STATUS_OK = 'ok'.freeze
    STATUS_FAIL = 'fail'.freeze

    attr_reader :json_body, :raw_response

    def initialize(raw_response)
      @raw_response = raw_response
      @json_body = JSON.parse raw_response.body
    end

    def is_ok?
      @json_body['status'] == STATUS_OK
    end

    def code
      @raw_response.code
    end
  end
end
