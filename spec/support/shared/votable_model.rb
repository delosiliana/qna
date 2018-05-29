shared_examples_for 'Votable Model' do
  describe '#vote' do
    it 'votes count' do
      expect{ another.vote(user, 1) }.to change(Vote, :count).by 1
    end

    context 'create a vote with the desired parameters' do
      before { @vote = another.vote(user, -1) }

      it 'belongs to resource id' do
        expect(@vote.votable_id).to eq another.id
      end

      it 'has polymorphic association resource object' do
        expect(@vote.votable_type).to eq object
      end

      it 'belongs to user' do
        expect(@vote.user_id).to eq user.id
      end

      it 'downvotes the count' do
        expect(@vote.count).to eq -1
      end
    end
  end

  describe '#vote?' do
    let!(:vote_up) { create(:vote, :up, user: user, votable: question) }

    it 'return true if user have the right to vote' do
      expect(question.vote?(user, 1)).to eq true
    end

    it 'return false if the user does not have the right to vote' do
      expect(another.vote?(user, 1)).to eq false
    end
  end
end
