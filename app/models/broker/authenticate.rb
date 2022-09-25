module Broker
  class Authenticate < ::Micro::Case
    attribute :token

    def call!
      return Failure(:unauthorized) if token != ENV['BROKER_TOKEN']

      Success(:authorized)
    end
  end
end
