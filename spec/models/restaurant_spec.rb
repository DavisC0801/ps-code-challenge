require "./spec/rails_helper"
require 'csv'

RSpec.describe Restaurant, type: :model do

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end

  describe 'class methods' do
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
      end
    end

    it "finds the stats for restaurants grouped by post code" do
      stats = Restaurant.find_post_code_stats
      # cherry picking stats for edge cases, manually confirmed
      expect(stats[0].post_code).to eq("LS10 1JQ")
      expect(stats[0].total_places).to eq(1)
      expect(stats[0].total_chairs).to eq(35)
      expect(stats[0].chairs_pct).to be_within(0.01).of(1.68)

      expect(stats[4].post_code).to eq("LS1 2HD")
      expect(stats[4].total_places).to eq(3)
      expect(stats[4].total_chairs).to eq(50)
      expect(stats[4].chairs_pct).to be_within(0.01).of(2.41)

      expect(stats[-1].post_code).to eq("LS7 3PD")
      expect(stats[-1].total_places).to eq(1)
      expect(stats[-1].total_chairs).to eq(32)
      expect(stats[-1].chairs_pct).to be_within(0.01).of(1.54)

      expect(stats.to_a.count).to eq(52)
    end

    it "finds the stats for maximum chairs groupwise to post codes" do
      stats = Restaurant.find_seat_stats
      # matching fields with above tests
      expect(stats[0].place_with_max_chairs).to eq("The Adelphi")
      expect(stats[0].max_chairs).to eq(35)

      expect(stats[4].place_with_max_chairs).to eq("Reds Barbecue")
      expect(stats[4].max_chairs).to eq(40)

      expect(stats[-1].place_with_max_chairs).to eq("Prohibition")
      expect(stats[-1].max_chairs).to eq(32)

      expect(stats.to_a.count).to eq(52)
    end
  end
end
