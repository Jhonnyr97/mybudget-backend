require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions" do

    it "create user and response token" do
      post "/signup", params: { email: 'test@example.com', password: "test1234" }
      expect(response.content_type).to include('application/json')
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to include('token')
		end

    it "create user invalid" do
      post "/signup"
      expect(response.content_type).to include('application/json')
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to include('error')
    end

    it "login user" do
			create(:user, email: 'test@example.com', password: 'test1234')
      post "/login", params: { email: 'test@example.com', password: "test1234" }
      expect(response.content_type).to include('application/json')
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to include('token')
		end

    it "login user invalid" do
      post "/login", params: { email: 'test@example.com', password: "test1234" }
      expect(response.content_type).to include('application/json')
			expect(response.status).to eq 400
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to include('error')
		end
	end
	describe "get user info" do
		before do
      create(:user, email: 'test@example.com', password: 'test1234')
      post "/login", params: { email: 'test@example.com', password: "test1234" }
		end
    
    it 'get details of user' do
			json_token = JSON.parse(response.body)
			get "/user", headers: {:Authorization => "Bearer #{json_token["token"]}"}
      expect(response.content_type).to include('application/json')
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to include('user')
      expect(hash_body['user'].keys).to match_array(%w[id email password_digest created_at updated_at])
		end
    
    it 'get details of user without access' do
      json_token = JSON.parse(response.body)
      get "/user"
      expect(response.content_type).to include('application/json')
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body).to include('error')
    end
	end
end
