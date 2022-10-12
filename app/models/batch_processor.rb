require 'concurrent'

class BatchProcessor
  attr_reader :buffer, :mutex

  def initialize
    @buffer = []
    @mutex = Mutex.new
  end

  def push(data)
    mutex.synchronize { buffer << data }
  end

  def start_timer(execution_interval: 1, timeout_interval: 1)
    @timer = Concurrent::TimerTask.execute({ execution_interval:, timeout_interval: }) { flush }
  end

  def stop_timer
    @timer.shutdown
  end

  def flush
    batch = []

    mutex.synchronize do
      batch.concat(buffer)
      buffer.clear
    end

    process(batch) unless batch.empty?
  end

  private

  def process(batch)
    raise NotImplementedError
  end
end

