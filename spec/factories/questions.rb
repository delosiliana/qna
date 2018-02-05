FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "MyText #{n}" }
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end

  #factory :questions, class: Question do
  #  sequence(:title) { |n| "Title #{n}" }
  #  sequence(:body) { |n| "MyText #{n}" }
  #end
end
