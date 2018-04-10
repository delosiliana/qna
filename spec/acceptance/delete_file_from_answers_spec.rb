require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  In order delete my answer files
  As an answer author
  I want to be able to delete files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Author delete files', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Delete file'

      expect(page).to have_no_link 'spec_helper.rb'
    end
  end

  scenario 'No author try delete file', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Delete file'
    end
  end
end
