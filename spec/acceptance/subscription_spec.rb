require_relative 'acceptance_helper'

feature 'Subscribe and unsubscribe question', %q{
  User can subscribe question
  User can unscubscribe question
} do

  given(:user) { @user || create(:user) }
  given(:no_author) { create(:user) }
  given!(:question) { create(:question, user: no_author ) }
  given(:subscribed_question) { create(:question, user: no_author) }

  scenario 'Authenticated user can subscribe  ans unsubscribe question', js: true do
    sign_in(user)
    visit question_path(question)

    within ".subscription" do
      expect(page).to have_link('Subscribe to question')
      click_link 'Subscribe to question'
      expect(page).to have_link('Unsubscribe to question')
      click_link 'Unsubscribe to question'
      expect(page).to have_link('Subscribe to question')
    end
  end

  scenario ' Not authenticated user cant subscribe', js: true do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe to question')
  end
end
