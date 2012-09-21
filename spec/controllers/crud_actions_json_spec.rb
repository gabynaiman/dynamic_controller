require 'spec_helper'

describe CountriesController, '-> JSON', type: :controller do

  it 'Index -> GET /resources.json' do
    3.times { create :country }

    get :index, format: :json

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    JSON.parse(response.body).each do |attributes|
      attributes['name'].should eq Country.find(attributes['id']).name
    end
  end

  it 'Show -> GET /resources/:id.json' do
    country = create :country

    get :show, format: :json, id: country.id

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    attributes = JSON.parse(response.body)
    attributes['id'].should eq country.id
    attributes['name'].should eq country.name
  end

  context 'Create -> POST /resources.json' do

    it 'Successfully' do
      attributes = attributes_for :country

      post :create, format: :json, country: attributes

      response.status.should eq 201 # Created
      response.content_type.should eq 'application/json'
      country = JSON.parse(response.body)
      country['id'].should_not be_nil
      country['name'].should eq attributes[:name]

      Country.find_by_id(country['id']).should_not be_nil
    end

    it 'With errors' do
      post :create, format: :json

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  context 'Update -> PUT /resources/:id.json' do

    it 'Successfully' do
      country = create :country
      attributes = {name: "#{country.name} updated"}

      put :update, format: :json, id: country.id, country: attributes

      response.status.should eq 204 # No Content
      response.content_type.should eq 'application/json'

      Country.find(country.id).name.should eq attributes[:name]
    end

    it 'With errors' do
      country = create :country

      put :update, format: :json, id: country.id, country: {name: nil}

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  it 'Destroy -> DELETE /resources/:id.json' do
    country = create :country

    delete :destroy, format: :json, id: country.id

    response.status.should eq 204 # No Content
    response.content_type.should eq 'application/json'

    Country.find_by_id(country.id).should be_nil
  end

end