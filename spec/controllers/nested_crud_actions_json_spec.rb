require 'spec_helper'

describe CitiesController, '-> JSON', type: :controller do

  it 'Index -> GET /parent_resource/:parent_id/resources.json' do
    country = create :country
    3.times { create :city, country: country }

    get :index, format: :json, country_id: country.id

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    JSON.parse(response.body).each do |attributes|
      attributes['name'].should eq City.find(attributes['id']).name
    end
  end

  it 'Show -> GET /parent_resource/:parent_id/resources/:id.json' do
    city = create :city

    get :show, format: :json, id: city.id, country_id: city.country.id

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    attributes = JSON.parse(response.body)
    attributes['id'].should eq city.id
    attributes['name'].should eq city.name
    attributes['country_id'].should eq city.country.id
  end

  context 'Create -> POST /parent_resource/:parent_id/resources.json' do

    it 'Successfully' do
      country = create :country
      attributes = attributes_for :city

      post :create, format: :json, city: attributes, country_id: country.id

      response.status.should eq 201 # Created
      response.content_type.should eq 'application/json'
      city = JSON.parse(response.body)
      city['id'].should_not be_nil
      city['name'].should eq attributes[:name]
      city['country_id'].should eq country.id

      City.find_by_id(city['id']).should_not be_nil
    end

    it 'With errors' do
      country = create :country

      post :create, format: :json, country_id: country.id

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  context 'Update -> PUT /parent_resource/:parent_id/resources/:id.json' do

    it 'Successfully' do
      city = create :city
      attributes = {name: "#{city.name} updated"}

      put :update, format: :json, id: city.id, city: attributes, country_id: city.country_id

      response.status.should eq 204 # No Content
      response.content_type.should eq 'application/json'

      City.find(city.id).name.should eq attributes[:name]
    end

    it 'With errors' do
      city = create :city

      put :update, format: :json, id: city.id, city: {name: nil}, country_id: city.country_id

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  it 'Destroy -> DELETE /parent_resource/:parent_id/resources/:id.json' do
    city = create :city

    delete :destroy, format: :json, id: city.id, country_id: city.country_id

    response.status.should eq 204 # No Content
    response.content_type.should eq 'application/json'

    City.find_by_id(city.id).should be_nil
  end

end