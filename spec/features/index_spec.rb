require "./spec/rails_helper"
require 'csv'

RSpec.describe "As a visitor", type: :feature do
  describe 'when I visit /restaurants' do
    it "loads a page" do
      visit restaurants_path()

      expect(page.status_code).to eq(200)
      expect(current_path).to eq(restaurants_path())
    end
  end
end
