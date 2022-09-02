module Users
  class Login < ::Micro::Case
    attribute :email, default: ->(value) { value&.to_s&.strip }
    attribute :password, default: ->(value) { value&.to_s&.strip }

    def call!
      user = User.find_by(email:)

      return Failure(:not_found, result: { errors: { id: ['not found'] } }) if user.nil?
      
      unless user.authenticate(password)
        return Failure(
          :invalid_password, 
          result: { errors: { password: ['is invalid'] } }
        )
      end
      
      token = generate_token({ exp: (Date.today + 1.month).to_time.to_i, id: user.id, email: user.email })

      Success(result: { token: })
    end

    private

    def generate_token(payload)
      secret_key = Rails.application.credentials.secret_key

      JWT.encode payload, secret_key, 'HS256'
    end
  end
end
