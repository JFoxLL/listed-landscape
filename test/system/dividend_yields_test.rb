require "application_system_test_case"

class DividendYieldsTest < ApplicationSystemTestCase
  setup do
    @dividend_yield = dividend_yields(:one)
  end

  test "visiting the index" do
    visit dividend_yields_url
    assert_selector "h1", text: "Dividend yields"
  end

  test "should create dividend yield" do
    visit dividend_yields_url
    click_on "New dividend yield"

    click_on "Create Dividend yield"

    assert_text "Dividend yield was successfully created"
    click_on "Back"
  end

  test "should update Dividend yield" do
    visit dividend_yield_url(@dividend_yield)
    click_on "Edit this dividend yield", match: :first

    click_on "Update Dividend yield"

    assert_text "Dividend yield was successfully updated"
    click_on "Back"
  end

  test "should destroy Dividend yield" do
    visit dividend_yield_url(@dividend_yield)
    click_on "Destroy this dividend yield", match: :first

    assert_text "Dividend yield was successfully destroyed"
  end
end
