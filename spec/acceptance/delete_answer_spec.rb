require_relative 'acceptance_helper'

feature 'Delete answer only author', %q{
  In order delete answer
  As an authenticated user
  I want to delete my answers
} do

  given!(:user) { create :user }
  given(:no_author) { create :user }
  given(:question) { create :question }
  given!(:answer) { create(:answer, user: user, question: question) }


  scenario 'Non author want to delete answer' do
    sign_in(no_author)
    visit question_path(question)

    expect(page).to have_no_content 'Delete answer'
  end

  scenario 'Author delete answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_no_content(answer.body)
  end

  scenario 'Non authenticated user want delete answer' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete answer'
  end
end
