require "mongo_mapper"
require "active_support/notifications"
require "sql_metrics/mute_middleware"
require "sql_metrics/engine"

# Setup the MongoMapper
MongoMapper.database = "sql_metrics-#{Rails.env}"

# Metrics store into mongoDB unless the metric is mute.
ActiveSupport::Notifications.subscribe /^sql\./ do |*args|
  SqlMetrics::Metric.store!(args) unless SqlMetrics.mute?
end
