Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }

  config.on(:startup) do
    messages_batch_processor = ::Broker::Messages::BatchProcessor.instance
    data_points_batch_writer = ::Devices::Variables::DataPoints::BatchWriter.instance

    messages_batch_processor.start_timer
    data_points_batch_writer.start_timer

    ::Broker::Messages::Monitor.start

    at_exit do
      messages_batch_processor.stop_timer
      messages_batch_processor.flush

      data_points_batch_writer.stop_timer
      data_points_batch_writer.flush
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
