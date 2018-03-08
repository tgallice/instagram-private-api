module Instagram
  module Exceptions
    class InstagramException < StandardError; end
    class LoginRequiredException < InstagramException; end
    class CheckpointRequiredException < InstagramException; end
    class ChallengeRequiredException < InstagramException; end
    class FeedbackRequiredException < InstagramException; end
    class IncorrectPasswordException < InstagramException; end
    class InvalidSmsCodeException < InstagramException; end
    class AccountDisabledException < InstagramException; end
    class SentryBlockException < InstagramException; end
    class InvalidUserException < InstagramException; end
    class ForcedPasswordResetException < InstagramException; end
    class BadRequestException < InstagramException; end
    class NotFoundException < InstagramException; end
    class EndpointException < InstagramException; end

    STRING_EXCEPTION_MAP = {
      "login_required" => LoginRequiredException,
      "checkpoint_required" => CheckpointRequiredException,
      "checkpoint_challenge_required" => CheckpointRequiredException,
      "challenge_required" => ChallengeRequiredException,
      "feedback_required" => FeedbackRequiredException,
      "bad_password" => IncorrectPasswordException,
      "sms_code_validation_code_invalid" => InvalidSmsCodeException,
      "sentry_block" => SentryBlockException,
      "invalid_user" => InvalidUserException
    }

    REGEX_EXCEPTION_MAP = {
      /password(.*?)incorrect/ => IncorrectPasswordException,
      /check(.*?)security(.*?)code/ => InvalidSmsCodeException,
      /account(.*?)disabled(.*?)violating/ => AccountDisabledException,
      /username(.*?)doesn't(.*?)belong/ => InvalidUserException,
      /reset(.*?)password/ => ForcedPasswordResetException
    }

    def self.throw(response)
      body = response.json_body
      messages = [extract_message(body), body['error_type']].compact

      messages.each do |message|
        unless STRING_EXCEPTION_MAP[message].nil?
          raise STRING_EXCEPTION_MAP[message].new(message)
        end

        REGEX_EXCEPTION_MAP.each_with_index do |(regex, klass)|
          raise klass.new(message) if regex =~ message
        end
      end

      case response.code
      when '400'
        raise BadRequestException.new(messages.first)
      when '404'
        raise NotFoundException.new(messages.first)
      else
        raise EndpointException.new(messages.first)
      end
    end

    def self.extract_message(body)
      if body['message'].is_a? String
        return message
      elsif body['message'].is_a? Array
        body['message'].join(', ');
      else
        raise InstagramException.new(body.to_json)
      end
    end
  end
end
