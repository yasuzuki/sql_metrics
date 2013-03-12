class ActiveSupport::IntegrationCase < ActiveSupport::TestCase
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  Capybara.app = Rails.application

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end