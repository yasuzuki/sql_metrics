require "mongo_mapper"
require "sql_metrics/metrics"
require "active_support/notifications"

# Setup the MongoMapper
MongoMapper.database = "sql_metrics-#{Rails.env}"

ActiveSupport::Notifications.subscribe /^sql\./ do |*args|
  SqlMetrics::Metric.store!(args)
end
