require_relative 'acceptance_helper'

feature 'User sign out', %{
  In order to be able to logout for complete the session
  As authenticated user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Sign out' do
    sign_in(user)

    visit root_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end
end
