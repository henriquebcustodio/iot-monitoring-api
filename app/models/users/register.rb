module Users
  class Register < ::Micro::Case
    attribute :email, default: ::Utils::ToStrippedString
    attribute :password, default: ::Utils::ToStrippedString
    attribute :password_confirmation, default: ::Utils::ToStrippedString

    def call!
      errors = {}

      errors[:email] = ["can't be blank"] if email.blank?
      errors[:password] = ["can't be blank"] if password.blank?
      errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

      return Failure(:validation_error, result: { errors: }) if errors.present?

      if password != password_confirmation
        return Failure(
          :wrong_password_confirmation,
          result: { errors: { password_confirmation: ["doesn't match password"] } }
        )
      end

      user = User.new(
        email:,
        password:,
        password_confirmation:
      )

      if user.save
        token = generate_token({ exp: (Date.today + 1.month).to_time.to_i, id: user.id, email: user.email })

        Success(:user_created, result: { user: user.as_json(except: [:password_digest]).merge({ token: }) })
      else
        Failure(:validation_error, result: { errors: user.errors.as_json })
      end
    end

    def generate_token(payload)
      secret_key = Rails.application.credentials.secret_key

      JWT.encode payload, secret_key, 'HS256'
    end
  end
end
