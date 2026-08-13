require "application_system_test_case"

class PagesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_path

    assert_selector "h1", text: "Pages"
  end
end
