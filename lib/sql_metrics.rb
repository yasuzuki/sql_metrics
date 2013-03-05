require "mongo_mapper"
require "active_support/notifications"
require "sql_metrics/engine"

# Setup the MongoMapper
MongoMapper.database = "sql_metrics-#{Rails.env}"

ActiveSupport::Notifications.subscribe /^sql\./ do |*args|
  SqlMetrics::Metric.store!(args)
end
