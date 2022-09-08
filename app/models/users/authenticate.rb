module Users
  class Authenticate < ::Micro::Case
    attribute :token, default: ::Utils::ToStrippedString

    def call!
      decoded_token = decode_token(token)

      Success(:authenticated, result: { token_payload: decoded_token.first })
      
    rescue JWT::ExpiredSignature
      Failure(:expired_token, result: { errors: { token: 'is expired' } })

    rescue JWT::DecodeError
      Failure(:invalid_token, result: { errors: { token: 'is invalid' } })
    end

    private

    def decode_token(token)
      JWT.decode(
        token,
        Rails.application.credentials.secret_key,
        true,
        { algorithm: 'HS256' }
      )
    end
  end
end
