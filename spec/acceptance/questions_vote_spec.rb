require_relative 'acceptance_helper'

feature 'voting question', %q{
  as authenticated user
  i want to able vote to question
  Not the author of the question can vote
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'any user try to vote' do
    visit question_path(question)

    expect(page).to_not have_content 'vote up'
    expect(page).to_not have_content 'vote down'
  end

  scenario 'user try to vote for not his question', js: true do
    sign_in(user)
    visit question_path(question)

    votes = find('.total_votes').text.to_i
    click_on 'vote up'
    sleep(1)

    expect(find('.total_votes').text.to_i).to eq votes + 1
  end

  describe 'user can revote' do
    before { sign_in user }

    scenario 'revote up to down', js: true do
      create(:vote, :up, user: user, votable: question)
      visit question_path(question)
      votes = find(".total_votes").text.to_i
      click_on 'vote down'
      sleep(1)

      expect(find('.total_votes').text.to_i).to eq votes - 2
    end

    scenario 'revote down to up', js: true do
      create(:vote, :down, user: user, votable: question)
      visit question_path(question)
      votes = find(".total_votes").text.to_i
      click_on 'vote up'
      sleep(1)

      expect(find('.total_votes').text.to_i).to eq votes + 2
    end
  end

  describe 'the user has already voted' do
    before { sign_in(user) }

    scenario 'voted up', js: true do
      create(:vote, :up, user: user, votable: question)
      visit question_path(question)
      votes = find(".total_votes").text.to_i
      click_on 'vote up'

      expect(find('.total_votes').text.to_i).to eq votes
      expect(page).to have_content 'You already voted'
    end

    scenario 'voted down', js: true do
      create(:vote, :down, user: user, votable: question)
      visit question_path(question)
      votes = find(".total_votes").text.to_i
      click_on 'vote down'

      expect(find('.total_votes').text.to_i).to eq votes
      expect(page).to have_content 'You already voted'
    end
  end
end
