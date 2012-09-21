require 'spec_helper'

describe StreetsController, '-> JSON', type: :controller do

  it 'Index -> GET /first_resource/:first_id/second_resource/:second_id/resources.json' do
    city = create :city
    3.times { create :street, city: city }

    get :index, format: :json, city_id: city.id, country_id: city.country.id

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    JSON.parse(response.body).each do |attributes|
      attributes['name'].should eq Street.find(attributes['id']).name
    end
  end

  it 'Show -> GET /first_resource/:first_id/second_resource/:second_id/resources/:id.json' do
    street = create :street

    get :show, format: :json, id: street.id, city_id: street.city.id, country_id: street.city.country.id

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    attributes = JSON.parse(response.body)
    attributes['id'].should eq street.id
    attributes['name'].should eq street.name
    attributes['city_id'].should eq street.city.id
  end

  context 'Create -> POST /first_resource/:first_id/second_resource/:second_id/resources.json' do

    it 'Successfully' do
      city = create :city
      attributes = attributes_for :street

      post :create, format: :json, street: attributes, city_id: city.id, country_id: city.country.id

      response.status.should eq 201 # Created
      response.content_type.should eq 'application/json'
      street = JSON.parse(response.body)
      street['id'].should_not be_nil
      street['name'].should eq attributes[:name]
      street['city_id'].should eq city.id

      Street.find_by_id(street['id']).should_not be_nil
    end

    it 'With errors' do
      city = create :city

      post :create, format: :json, city_id: city.id, country_id: city.country.id

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  context 'Update -> PUT /first_resource/:first_id/second_resource/:second_id/resources/:id.json' do

    it 'Successfully' do
      street = create :street
      attributes = {name: "#{street.name} updated"}

      put :update, format: :json, id: street.id, street: attributes, city_id: street.city_id, country_id: street.city.country.id

      response.status.should eq 204 # No Content
      response.content_type.should eq 'application/json'

      Street.find(street.id).name.should eq attributes[:name]
    end

    it 'With errors' do
      street = create :street

      put :update, format: :json, id: street.id, street: {name: nil}, city_id: street.city_id, country_id: street.city.country.id

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  it 'Destroy -> DELETE /first_resource/:first_id/second_resource/:second_id/resources/:id.json' do
    street = create :street

    delete :destroy, format: :json, id: street.id, city_id: street.city_id, country_id: street.city.country.id

    response.status.should eq 204 # No Content
    response.content_type.should eq 'application/json'

    Street.find_by_id(street.id).should be_nil
  end

end