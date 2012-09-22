require 'spec_helper'

describe LanguagesController, '-> JSON', type: :controller do

  it 'Index -> GET /resources.json' do
    3.times { create :language }

    get :index, format: :json

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    JSON.parse(response.body).each do |attributes|
      attributes['name'].should eq Language.find(attributes['id']).name
    end
  end

  it 'Show -> GET /resources/:id.json' do
    language = create :language

    get :show, format: :json, id: language.id

    response.status.should eq 200 # OK
    response.content_type.should eq 'application/json'
    attributes = JSON.parse(response.body)
    attributes['id'].should eq language.id
    attributes['name'].should eq language.name
  end

  context 'Create -> POST /resources.json' do

    it 'Successfully' do
      attributes = attributes_for :language

      post :create, format: :json, language: attributes

      response.status.should eq 201 # Created
      response.content_type.should eq 'application/json'
      language = JSON.parse(response.body)
      language['id'].should_not be_nil
      language['name'].should eq attributes[:name]

      Language.find_by_id(language['id']).should_not be_nil
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
      language = create :language
      attributes = {name: "#{language.name} updated"}

      put :update, format: :json, id: language.id, language: attributes

      response.status.should eq 200 # Ok
      response.content_type.should eq 'application/json'
      json = JSON.parse(response.body)
      json['id'].should eq language.id
      json['name'].should eq attributes[:name]

      Language.find(language.id).name.should eq attributes[:name]
    end

    it 'With errors' do
      language = create :language

      put :update, format: :json, id: language.id, language: {name: nil}

      response.status.should eq 422 # Unprocessable Entity
      response.content_type.should eq 'application/json'
      JSON.parse(response.body).should have_key 'name'
    end

  end

  it 'Destroy -> DELETE /resources/:id.json' do
    language = create :language

    delete :destroy, format: :json, id: language.id

    response.status.should eq 204 # No Content
    response.content_type.should eq 'application/json'

    Language.find_by_id(language.id).should be_nil
  end

end