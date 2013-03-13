require "mongo_mapper"
require "active_support/notifications"
require "sql_metrics/mute_middleware"
require "sql_metrics/engine"
require "thread"

# Setup the MongoMapper
MongoMapper.database = "sql_metrics-#{Rails.env}"

module SqlMetrics
  def self.queue
    @queue ||= Queue.new
  end

  def self.thread
    @thread ||= Thread.new do
      while args = queue.pop
        SqlMetrics::Metric.store!(args)
      end
    end
  end

  def self.finish!
    queue << nil
    thread.join
    @thread = nil
    thread
  end
end


# Start the Queue and Thread
SqlMetrics.queue
SqlMetrics.thread

# Metrics store into mongoDB unless the metric is mute.
ActiveSupport::Notifications.subscribe /^sql\./ do |*args|
  SqlMetrics::Metric.store!(args) unless SqlMetrics.mute?
end
