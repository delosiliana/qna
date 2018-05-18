require_relative 'acceptance_helper'

feature 'User sign up', %q{
  In order to be able to ask question and answer the questions
  As an user
  I want to be able to sign up
} do

  scenario 'Non-registered user try to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    open_email('user@test.com')
    expect(current_email).to have_content 'You can confirm your account email through the link below:'
    current_email.click_link('Confirm my account')
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end

