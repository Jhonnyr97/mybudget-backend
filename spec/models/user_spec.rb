require 'rails_helper'

RSpec.describe User, type: :model do
	it "is valid with valid attributes" do
		expect(User.new(email: 'test@test.com', password: 'test1234')).to be_valid
	end
	
	it "is not valid without attributes" do
		expect(User.new).to be_invalid
	end

	it "is not valid without email" do
		expect(User.new(password: 'test1234')).to be_invalid
	end
end
