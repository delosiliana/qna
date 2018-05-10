require_relative 'acceptance_helper'

feature 'Any user can comment to answer', %{
  In order comment someone's answer
  As a any user
  I want to be able add comment
} do

  given(:user) { create(:user) }

  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }


  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user can add comment to answer', js: true do

      within '.answers' do
        click_on 'Add comment'
        fill_in 'Comment', with: 'New comment'
        click_on 'Сomment'

        expect(page).to have_content 'New comment'
      end
    end

    scenario 'User tries to create can add comment invalid params to answer', js: true do

      within '.answers' do
        click_on 'Add comment'
        click_on 'Сomment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'No authenticate user tries to add comment' do
    expect(page).to_not have_link 'Add comment'
  end

  context 'multiply sessions' do
    scenario 'added comments to answer can be seen another user', js:  true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          click_on 'Add comment'
          fill_in 'Comment', with: 'New comment to answer'
          click_on 'Сomment'

          expect(page).to have_content 'New comment to answer'
        end
      end

      Capybara.using_session('quest') do
        within '.answers' do

          expect(page).to have_content 'New comment to answer'
        end
      end
    end
  end
end
