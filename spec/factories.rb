FactoryGirl.define do

  factory :country do
    sequence(:name) { |s| "Country #{s}" }
  end

  factory :city do
    sequence(:name) { |s| "City #{s}" }
    country
  end

end
