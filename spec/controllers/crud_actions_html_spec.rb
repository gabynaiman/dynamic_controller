require 'spec_helper'

describe CountriesController, '-> HTML', type: :controller do

  it 'Index -> GET /resources' do
    3.times { create :country }

    get :index

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :index
    assigns(:countries).should eq Country.all
  end

  it 'Show -> GET /resources/:id' do
    country = create :country

    get :show, id: country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :show
    assigns(:country).should eq country
  end

  it 'New -> GET /resources/new' do
    get :new

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :new
    assigns(:country).should be_a Country
    assigns(:country).should be_new_record
  end

  it 'Edit -> GET /resources/:id/edit' do
    country = create :country

    get :edit, id: country.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :edit
    assigns(:country).should eq country
  end

  context 'Create -> POST /resources' do

    it 'Successfully' do
      attributes = attributes_for :country

      post :create, country: attributes

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to assigns(:country)
      assigns(:country).id.should_not be_nil
      assigns(:country).name.should eq attributes[:name]
    end

    it 'With errors' do
      post :create

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :new
      assigns(:country).should have(1).errors_on(:name)
    end

  end

  context 'Update -> PUT /resources/:id' do

    it 'Successfully' do
      country = create :country
      attributes = {name: "#{country.name} updated"}

      put :update, id: country.id, country: attributes

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to country
      assigns(:country).name.should eq attributes[:name]
    end

    it 'With errors' do
      country = create :country

      put :update, id: country.id, country: {name: nil}

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :edit
      assigns(:country).should have(1).errors_on(:name)
    end

  end

  it 'Destroy -> DELETE /resources/:id' do
    country = create :country

    delete :destroy, id: country.id

    response.should be_redirect
    response.content_type.should eq 'text/html'
    response.should redirect_to countries_path

    Country.find_by_id(country.id).should be_nil
  end

end