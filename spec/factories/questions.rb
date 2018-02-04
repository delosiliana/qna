FactoryBot.define do
  factory :question do
    title "MyString"
    body "MyText"
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end

  factory :questions, class: Question do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "MyText #{n}" }
  end
end
