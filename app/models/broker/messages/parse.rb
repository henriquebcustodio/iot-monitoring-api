module Broker
  module Messages
    Parse = lambda do |message|
      return unless ::Kind::String?(message)

      ::JSON.parse(message)

    rescue ::StandardError
      return
    end
  end
end
