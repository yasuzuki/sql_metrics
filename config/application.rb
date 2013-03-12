class Application < ::Rails::Applicaiton
  config.sql_metrics.mute_regexp = %r{^/admin}
end