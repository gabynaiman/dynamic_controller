require 'spec_helper'

describe StreetsController, '-> HTML', type: :controller do

  it 'Index -> GET /first_resource/:first_id/second_resource/:second_id/resources' do
    city = create :city
    3.times { create :street, city: city }

    get :index, city_id: city.id, country_id: city.country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :index
    assigns(:streets).should eq Street.all
    assigns(:city).should eq city
    assigns(:country).should eq city.country
    assigns(:search).should be_a Ransack::Search
  end

  it 'Show -> GET /first_resource/:first_id/second_resource/:second_id/resources/:id' do
    street = create :street

    get :show, id: street.id, city_id: street.city_id, country_id: street.city.country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :show
    assigns(:street).should eq street
    assigns(:city).should eq street.city
    assigns(:country).should eq street.city.country
  end

  it 'New -> GET /first_resource/:first_id/second_resource/:second_id/resources/new' do
    city = create :city

    get :new, city_id: city.id, country_id: city.country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :new
    assigns(:street).should be_a Street
    assigns(:street).should be_new_record
    assigns(:city).should eq city
    assigns(:country).should eq city.country
  end

  it 'Edit -> GET /first_resource/:first_id/second_resource/:second_id/resources/:id/edit' do
    street = create :street

    get :edit, id: street.id, city_id: street.city_id, country_id: street.city.country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :edit
    assigns(:street).should eq street
    assigns(:city).should eq street.city
    assigns(:country).should eq street.city.country
  end

  context 'Create -> POST /first_resource/:first_id/second_resource/:second_id/resources' do

    it 'Successfully' do
      city = create :city
      attributes = attributes_for :street

      post :create, street: attributes, city_id: city.id, country_id: city.country.id

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to [city.country, city, assigns(:street)]
      assigns(:street).id.should_not be_nil
      assigns(:street).name.should eq attributes[:name]
      assigns(:city).should eq city
      assigns(:country).should eq city.country
    end

    it 'With errors' do
      city = create :city

      post :create, city_id: city.id, country_id: city.country.id, country_id: city.country.id

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :new
      assigns(:street).should have(1).errors_on(:name)
      assigns(:city).should eq city
      assigns(:country).should eq city.country
    end

  end

  context 'Update -> PUT /first_resource/:first_id/second_resource/:second_id/resources/:id' do

    it 'Successfully' do
      street = create :street
      attributes = {name: "#{street.name} updated"}

      put :update, id: street.id, street: attributes, city_id: street.city_id, country_id: street.city.country.id

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to [street.city.country, street.city, street]
      assigns(:street).name.should eq attributes[:name]
      assigns(:city).should eq street.city
      assigns(:country).should eq street.city.country
    end

    it 'With errors' do
      street = create :street

      put :update, id: street.id, street: {name: nil}, city_id: street.city_id, country_id: street.city.country.id

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :edit
      assigns(:street).should have(1).errors_on(:name)
      assigns(:city).should eq street.city
      assigns(:country).should eq street.city.country
    end

  end

  it 'Destroy -> DELETE /first_resource/:first_id/second_resource/:second_id/resources/:id' do
    street = create :street

    delete :destroy, id: street.id, city_id: street.city_id, country_id: street.city.country.id

    response.should be_redirect
    response.content_type.should eq 'text/html'
    response.should redirect_to country_city_streets_path(street.city.country, street.city)

    Street.find_by_id(street.id).should be_nil
  end

end