require 'test_helper'

class NavigationTest < ActiveSupport::IntegrationCase
  setup do
    Capybara.javascript_driver = :webkit
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
  end

  test 'can visualize and destroy notifications created in a request' do
    visit new_user_path
    fill_in "Name", with: "John Doe"
    fill_in "Age", with: "23"
    click_button "Create User"

    # Check for the metric data on the page
    visit sql_metrics_path
    assert_match "User Load", page.body
    assert_match "INSERT INTO", page.body
    assert_match "John Doe", page.body
    assert_match "sql.active_record", page.body

    # Assert the number of rows change when an item is destroyed
    assert_difference "all('table tr').count", -1 do
      first(:link, "Destroy").click
    end
  end
end