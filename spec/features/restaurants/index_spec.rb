require "./spec/rails_helper"
require 'csv'

RSpec.describe "As a visitor", type: :feature do
  before :each do
    # Using the full dataset for the fixture due to small size
    CSV.foreach('./Street Cafes 2015-16.csv', :headers => true, :encoding => "ISO-8859-1") do |row|
      new_resturant_data = row.to_hash
      new_resturant = Restaurant.create(
        name:new_resturant_data["Café/Restaurant Name"],
        address:new_resturant_data["Street Address"],
        post_code:new_resturant_data["Post Code"],
        number_of_chairs:new_resturant_data["Number of Chairs"],
      )
      new_resturant.determine_category
    end
  end

  describe 'when I visit /restaurants' do
    it "loads a page" do
      visit restaurants_path()

      expect(page.status_code).to eq(200)
      expect(current_path).to eq("/restaurants")
    end

    it "shows all data" do
      visit restaurants_path()

      within("table") do
        within("#header") do
          expect(page).to have_content("Post Code")
          expect(page).to have_content("Locations in this Post Code")
          expect(page).to have_content("Total chairs in this Post Code")
          expect(page).to have_content("Percentage of chairs in this Post Code")
          expect(page).to have_content("Location with most chairs")
          expect(page).to have_content("Number of chairs at largest location")
        end
        within("#restaurant_1") do
          expect(page).to have_content("LS10 1JQ")
          expect(page).to have_content("1")
          expect(page).to have_content("35")
          expect(page).to have_content("1.68%")
          expect(page).to have_content("The Adelphi")
          expect(page).to have_content("35")
        end
        within("#restaurant_5") do
          expect(page).to have_content("LS1 2HD")
          expect(page).to have_content("3")
          expect(page).to have_content("50")
          expect(page).to have_content("2.41%")
          expect(page).to have_content("Reds Barbecue")
          expect(page).to have_content("40")
        end
        within("#restaurant_52") do
          expect(page).to have_content("LS7 3PD")
          expect(page).to have_content("1")
          expect(page).to have_content("32")
          expect(page).to have_content("1.54%")
          expect(page).to have_content("Prohibition")
          expect(page).to have_content("32")
        end
      end
    end
  end
end
