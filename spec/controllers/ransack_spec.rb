require 'spec_helper'

describe CountriesController, '-> Ransack query search', type: :controller do

  it 'Filter by q[name_eq]' do
    3.times { create :country }

    country = Country.first

    get :index, q: {name_eq: country.name}

    response.should be_success
    assigns(:countries).should eq [country]
  end

  it 'Filter by attribute, predicate and value' do
    3.times { create :country }

    country = Country.first

    get :index, q: {c: [{a: {'0' => {name: 'name'}}, p: 'eq', v: {'0' => {value: country.name}}}]}

    response.should be_success
    assigns(:countries).should eq [country]
  end

  it 'Filter by NQL' do
    3.times { create :country }

    country = Country.first

    get :index, q: "name = #{country.name}"

    response.should be_success
    assigns(:countries).should eq [country]
  end

  it 'Filter by NQL with invalid field' do
    3.times { create :country }

    country = Country.first

    get :index, q: "abcd = #{country.name}"

    response.should be_success
    assigns(:countries).should eq []
  end

  it 'Filter by NQL with invalid expression' do
    3.times { create :country }

    get :index, q: 'abcd = '

    response.should be_success
    assigns(:countries).should eq []
  end

end