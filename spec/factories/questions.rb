FactoryBot.define do
  factory :question do
    title "MyString"
    body "MyText"

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
