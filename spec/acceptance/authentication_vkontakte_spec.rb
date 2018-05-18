require_relative 'acceptance_helper'

feature 'User sign_in with vkontakte', %q{
  In order to be able to ask question or answer
  As a any user
  I want to be able to sign_in using vkontakte for sign_up
} do

  given(:user) { create(:user) }

  describe "user sing in" do
    before do
      clear_emails
      visit new_user_session_path
    end

    scenario 'User try to sign_in and sign_up' do
      mock_vkontakte_auth_hash
      click_on 'Sign in with Vkontakte'
      fill_in 'Email', with: 'vkontakte@test.com'
      click_on 'Submit'

      open_email('vkontakte@test.com')
      current_email.click_link 'Confirm my account'

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account'
      expect(current_path).to eq root_path
    end

    scenario 'User fails twitter authentication' do
      mock_invalid_vkontakte_auth_hash
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content "Could not authenticate you from Vkontakte because \"Invalid credentials\"."
    end
  end
end
