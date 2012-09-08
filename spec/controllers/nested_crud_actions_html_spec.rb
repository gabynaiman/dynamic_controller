require 'spec_helper'

describe CitiesController, '-> HTML', type: :controller do

  it 'Index -> GET /resources' do
    country = create :country
    3.times { create :city, country: country }

    get :index, country_id: country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :index
    assigns(:cities).should eq City.all
    assigns(:country).should eq country
  end

  it 'Show -> GET /resources/:id' do
    city = create :city

    get :show, id: city.id, country_id: city.country_id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :show
    assigns(:city).should eq city
    assigns(:country).should eq city.country
  end

  it 'New -> GET /resources/new' do
    country = create :country

    get :new, country_id: country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :new
    assigns(:city).should be_a City
    assigns(:city).should be_new_record
    assigns(:country).should eq country
  end

  it 'Edit -> GET /resources/:id/edit' do
    city = create :city

    get :edit, id: city.id, country_id: city.country_id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :edit
    assigns(:city).should eq city
    assigns(:country).should eq city.country
  end

  context 'Create -> POST /resources' do

    it 'Successfully' do
      country = create :country
      attributes = attributes_for :city, country_id: country.id

      post :create, city: attributes, country_id: country.id

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to [country, assigns(:city)]
      assigns(:city).id.should_not be_nil
      assigns(:city).name.should eq attributes[:name]
      assigns(:country).should eq country
    end

    it 'With errors' do
      country = create :country
      post :create, country_id: country.id

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :new
      assigns(:city).should have(1).errors_on(:name)
      assigns(:country).should eq country
    end

  end

  context 'Update -> PUT /resources/:id' do

    it 'Successfully' do
      city = create :city
      attributes = {name: "#{city.name} updated"}

      put :update, id: city.id, city: attributes, country_id: city.country_id

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to [city.country, city]
      assigns(:city).name.should eq attributes[:name]
      assigns(:country).should eq city.country
    end

    it 'With errors' do
      city = create :city

      put :update, id: city.id, city: {name: nil}, country_id: city.country_id

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :edit
      assigns(:city).should have(1).errors_on(:name)
      assigns(:country).should eq city.country
    end

  end

  it 'Destroy -> DELETE /resources/:id' do
    city = create :city

    delete :destroy, id: city.id, country_id: city.country_id

    response.should be_redirect
    response.content_type.should eq 'text/html'
    response.should redirect_to country_cities_path(city.country)

    City.find_by_id(city.id).should be_nil
  end

end