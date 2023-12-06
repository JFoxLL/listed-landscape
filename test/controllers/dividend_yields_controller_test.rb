require "test_helper"

class DividendYieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dividend_yield = dividend_yields(:one)
  end

  test "should get index" do
    get dividend_yields_url
    assert_response :success
  end

  test "should get new" do
    get new_dividend_yield_url
    assert_response :success
  end

  test "should create dividend_yield" do
    assert_difference("DividendYield.count") do
      post dividend_yields_url, params: { dividend_yield: {  } }
    end

    assert_redirected_to dividend_yield_url(DividendYield.last)
  end

  test "should show dividend_yield" do
    get dividend_yield_url(@dividend_yield)
    assert_response :success
  end

  test "should get edit" do
    get edit_dividend_yield_url(@dividend_yield)
    assert_response :success
  end

  test "should update dividend_yield" do
    patch dividend_yield_url(@dividend_yield), params: { dividend_yield: {  } }
    assert_redirected_to dividend_yield_url(@dividend_yield)
  end

  test "should destroy dividend_yield" do
    assert_difference("DividendYield.count", -1) do
      delete dividend_yield_url(@dividend_yield)
    end

    assert_redirected_to dividend_yields_url
  end
end
