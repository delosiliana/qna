require_relative 'acceptance_helper'

feature 'User can view the questions', %q{
In order to be able to view questions
as a user
} do

  given(:questions) { create_list(:question, 2) }

  scenario 'User can view questions' do
    questions
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
