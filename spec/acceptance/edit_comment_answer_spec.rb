require_relative 'acceptance_helper'

feature 'Edit comment only author', %q{
  In order edit comment
  As an authenticated user
  I want to edit my comment
} do

  given(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }

  scenario 'Non author want to edit comment answer' do
    sign_in(no_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit comment'
    end
  end

  context 'Autor comment' do
    scenario 'Author edit comment answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit comment'

        fill_in 'Comment', with: 'Update comment answer'
        click_on 'Сomment'

        expect(page).to have_content 'Update comment answer'
        expect(page).to_not have_content comment.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Author edit comment invalid attributes to answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit comment'

        fill_in 'Comment', with: ''
        click_on 'Сomment'

        expect(page).to have_content comment.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non authenticated user want edit comment answer' do
    visit question_path(question)

    expect(page).to have_no_content 'Edit comment'
  end
end
