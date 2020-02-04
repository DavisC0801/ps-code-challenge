require "./spec/rails_helper"

RSpec.describe Restaurant, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end
end
