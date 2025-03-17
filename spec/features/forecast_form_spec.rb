require 'rails_helper'

RSpec.describe "Forecast Form", type: :feature do
  before do
    visit root_path
  end

  it "displays the form with all required fields" do
    expect(page).to have_field('forecast_request[street]')
    expect(page).to have_field('forecast_request[city]')
    expect(page).to have_field('forecast_request[state]')
    expect(page).to have_field('forecast_request[zip_code]')
    expect(page).to have_button('Get Forecast')
  end

  context "when submitting the form" do
    let!(:zip_code) { ZipCode.create!(code: '90210') }

    it "successfully submits with valid data" do
      fill_in 'forecast_request[street]', with: '123 Main St'
      fill_in 'forecast_request[city]', with: 'Los Angeles'
      select 'California', from: 'forecast_request[state]'
      fill_in 'forecast_request[zip_code]', with: '90210'
      
      click_button 'Get Forecast'
      
      expect(page.current_path).to start_with('/forecast')
    end

    it "shows validation errors with invalid data" do
      click_button 'Get Forecast'
      
      expect(page).to have_content("can't be blank")
    end
  end

  it "displays the instruction message" do
    expect(page).to have_content("Get Your Weather Forecast")
    expect(page).to have_content("Enter an address below to get the weather forecast")
  end
end
