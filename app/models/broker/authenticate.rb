module Broker
  class Authenticate < ::Micro::Case
    attribute :token

    def call!
      return Failure(:unauthenticated) if token != ENV['BROKER_TOKEN']

      Success(:authenticated)
    end
  end
end
