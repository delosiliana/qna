require_relative 'acceptance_helper'

feature 'Any user can comment to question', %{
  In order comment someone's question
  As a any user
  I want to be able add comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user can add comment to questiom', js: true do

      within '.comment_question' do
        click_on 'Add comment'
        fill_in 'Comment', with: 'New comment'
        click_on 'Сomment'

        expect(page).to have_content 'New comment'
      end
    end

    scenario 'User tries to create can add comment invalid params to question', js: true do

      within '.comment_question' do
        click_on 'Add comment'
        click_on 'Сomment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'No authenticate user tries to add comment' do
    expect(page).to_not have_link 'Add comment'
  end
end
