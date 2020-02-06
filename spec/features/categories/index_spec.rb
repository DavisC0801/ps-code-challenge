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
  
  describe 'when I visit /categories' do
    it "loads a page" do
      visit categories_path()

      expect(page.status_code).to eq(200)
      expect(current_path).to eq("/categories")
    end

    it "shows all data" do
      visit categories_path()

      within("table") do
        within("#header") do
          expect(page).to have_content("Category")
          expect(page).to have_content("Locations in this Category")
          expect(page).to have_content("Total chairs in this Category")
        end
        within("#category_other") do
          expect(page).to have_content("other")
          expect(page).to have_content("2")
          expect(page).to have_content("67")
        end
        within("#category_ls2_large") do
          expect(page).to have_content("ls2 large")
          expect(page).to have_content("4")
          expect(page).to have_content("438")
        end
        within("#category_ls1_large") do
          expect(page).to have_content("ls1 large")
          expect(page).to have_content("1")
          expect(page).to have_content("152")
        end
      end
    end
  end
end
