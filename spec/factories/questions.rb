FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "MyText #{n}" }
    user

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
