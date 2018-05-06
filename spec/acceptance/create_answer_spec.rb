require_relative 'acceptance_helper'

feature 'Create answer for question', %q{
  To be able to create answers for question
  As an authenticated user
  I want to be able to answers for question
} do

  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'Authenticated user can create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'Answer text'
    click_on 'Answer'

    expect(page).to have_content 'Answer text'
  end

  scenario 'The authenticated user tries to create a invalid answer', js: true do
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

  context 'mulitple sessions' do
    scenario "answers appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        visit question_path(question)
        fill_in 'Your answer', with: 'Answer text two'
        click_on 'Answer'

        expect(page).to have_content 'Answer text two'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer text two'
      end
    end
  end
end

