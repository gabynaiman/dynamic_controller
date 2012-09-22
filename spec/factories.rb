FactoryGirl.define do

  factory :country do
    sequence(:name) { |s| "Country #{s}" }
  end

  factory :city do
    sequence(:name) { |s| "City #{s}" }
    country
  end

  factory :street do
    sequence(:name) { |s| "Street #{s}" }
    city
  end

  factory :language do
    sequence(:name) { |s| "Language #{s}" }
  end

end
