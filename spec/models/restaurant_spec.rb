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

    it "categorizes restaurants by post code and size" do
      small_ls1 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS1 001", number_of_chairs: 5)
      medium_ls1 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS1 002", number_of_chairs: 50)
      medium_ls1_edge = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS1 002", number_of_chairs: 10)
      large_ls1 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS1 003", number_of_chairs: 500)
      large_ls1_edge = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS1 003", number_of_chairs: 100)

      small_ls2 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS2 001", number_of_chairs: 10)
      large_ls2 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS2 003", number_of_chairs: 60)

      other1 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS10 1JT", number_of_chairs: 35)
      other2 = Restaurant.new(name: "small_ls1", address: "123 fake St", post_code:"LS7 3PD", number_of_chairs: 32)

      small_ls1.determine_category
      expect(small_ls1.category).to eq("ls1 small")
      medium_ls1.determine_category
      expect(medium_ls1.category).to eq("ls1 medium")
      medium_ls1_edge.determine_category
      expect(medium_ls1_edge.category).to eq("ls1 medium")
      large_ls1.determine_category
      expect(large_ls1.category).to eq("ls1 large")
      large_ls1_edge.determine_category
      expect(large_ls1_edge.category).to eq("ls1 large")

      # Current 50th percentile cutoff is 57.3
      small_ls2.determine_category
      expect(small_ls2.category).to eq("ls2 small")
      large_ls2.determine_category
      expect(large_ls2.category).to eq("ls2 large")

      other1.determine_category
      expect(other1.category).to eq("other")
      other2.determine_category
      expect(other2.category).to eq("other")

      # expected behavior:
      # If the Post Code is of the LS1 prefix type:
        # of chairs less than 10: category = 'ls1 small'
        # of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'
        # of chairs greater than or equal to 100: category = 'ls1 large'
      # If the Post Code is of the LS2 prefix type:
        # of chairs below the 50th percentile for ls2: category = 'ls2 small'
        # of chairs above the 50th percentile for ls2: category = 'ls2 large'
      # For Post Code is something else:
        # category = 'other'
    end
  end
end
