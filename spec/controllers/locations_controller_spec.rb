require 'spec_helper'

describe LocationsController do
  before do
    User.destroy_all
    Location.destroy_all
    FactoryGirl.create_list(:location, 3)
    sign_in_user_via_vk(:master)
  end

  context 'requesting' do
    it '#index via text/html returns locations, current lat and lng' do
      get :index
      expect(assigns[:lat]).to eq 0.0
      expect(assigns[:lng]).to eq 0.0
      expect(assigns[:locations]).not_to be_empty
    end

    it '#index via json returns nearby locations' do
      get :index, {format: :json}
      expect(JSON.parse(response.body).count).to eq 3
    end
  end

end