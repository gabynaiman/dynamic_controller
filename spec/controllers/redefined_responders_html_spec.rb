require 'spec_helper'

describe LanguagesController, '-> HTML', type: :controller do

  it 'Index -> GET /resources' do
    3.times { create :language }

    get :index

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :index
    assigns(:languages).should eq Language.all
  end

  it 'Show -> GET /resources/:id' do
    language = create :language

    get :show, id: language.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :show
    assigns(:language).should eq language
  end

  it 'New -> GET /resources/new' do
    get :new

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :new
    assigns(:language).should be_a Language
    assigns(:language).should be_new_record
  end

  it 'Edit -> GET /resources/:id/edit' do
    language = create :language

    get :edit, id: language.id

    response.should be_success
    response.content_type.should eq 'text/html'
    response.should render_template :edit
    assigns(:language).should eq language
  end

  context 'Create -> POST /resources' do

    it 'Successfully' do
      attributes = attributes_for :language

      post :create, language: attributes

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to languages_path
      assigns(:language).id.should_not be_nil
      assigns(:language).name.should eq attributes[:name]
    end

    it 'With errors' do
      post :create

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :new
      assigns(:language).should have(1).errors_on(:name)
    end

  end

  context 'Update -> PUT /resources/:id' do

    it 'Successfully' do
      language = create :language
      attributes = {name: "#{language.name} updated"}

      put :update, id: language.id, language: attributes

      response.should be_redirect
      response.content_type.should eq 'text/html'
      response.should redirect_to languages_path
      assigns(:language).name.should eq attributes[:name]
    end

    it 'With errors' do
      language = create :language

      put :update, id: language.id, language: {name: nil}

      response.should be_success
      response.content_type.should eq 'text/html'
      response.should render_template :edit
      assigns(:language).should have(1).errors_on(:name)
    end

  end

  it 'Destroy -> DELETE /resources/:id' do
    language = create :language

    delete :destroy, id: language.id

    response.should be_redirect
    response.content_type.should eq 'text/html'
    response.should redirect_to languages_path

    Language.find_by_id(language.id).should be_nil
  end

end