require_relative 'acceptance_helper'

feature 'User can view question and answer', %q{
  To view the question with answers
} do

  given(:question) {create :question}
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'View question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
