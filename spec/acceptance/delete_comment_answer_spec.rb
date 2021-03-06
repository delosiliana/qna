require_relative 'acceptance_helper'

feature 'Delete comment only author', %q{
  In order delete comment
  As an authenticated user
  I want to delete my comment
} do

  given!(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }


  scenario 'Non author want to delete comment answer' do
    sign_in(no_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete comment'
    end
  end

  scenario 'Author delete comment answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Delete comment'
      expect(page).to have_no_content (comment.body)
    end
  end

  scenario 'Non authenticated user want delete comment answer' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete comment'
  end
end
