require 'rails_helper'

feature 'Create answer for question', %q{
  To be able to create answers for question
  As an authenticated user
  I want to be able to answers for question
} do

  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'Authenticated user can create answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'Answer text'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'Answer text'
  end

  scenario 'The authenticated user tries to create a invalid answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user ties user create answer' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in'
  end
end

