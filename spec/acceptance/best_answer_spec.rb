require_relative 'acceptance_helper'

feature 'User select best answer', %q{
  As an question author
  I want to be able to select best answer for question
} do
  given!(:author) { create :user }
  given!(:user) { create :user }
  given!(:question) { create :question, user: author, answers: create_list(:answer, 2) }

  scenario 'Author select best answer', js: true do
    sign_in(author)
    visit question_path(question)

    last_answer = question.answers.last

    within("#answer-#{last_answer.id }") do
      click_link('Note as best')
    end

    expect(page).to have_content 'Best answer'
    expect(first('.answers')).to have_content(last_answer.body)
  end

  scenario 'Authenticated user try to select best answer for no his question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_no_link 'Note as best'
  end

  scenario 'Unauthenticated user try to select best answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Note as best'
  end
end
