require 'rails_helper'

feature 'Delete question only author', %{
  In order delete question
  As an authenticated user
  I want to delete my questions
} do

  given(:user) { create :user }
  given(:no_author) { create :user }
  given(:question) { create(:question, user: user) }

  scenario 'Non author want to delete question' do
    sign_in(no_author)
    visit question_path(question)

    expect(page).to have_no_content 'Delete'
  end

  scenario 'Author delete question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_no_content (question.title)
  end

  scenario 'Not authenticated user delete question' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete question'
  end
end



