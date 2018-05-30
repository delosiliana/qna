shared_examples_for 'Votable Controller' do
  describe 'PATCH #vote_up' do
    login_user
    context 'noauthor try to vote up' do
      context 'user already has vote' do
        before { create(:vote, :up, user: @user, votable: object) }

        it 'dont change votes' do
          expect{ patch :vote_up, params: { question_id: question, id: object } }.to_not change(object.votes, :count)
        end

        it 'render error' do
          patch :vote_up, params: { question_id: question, id: object }
          expect(response.body).to eq 'You already voted'
        end

        it 'error 422' do
          patch :vote_up, params: { question_id: question, id: object }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'resource author try to vote up' do
      before { object.update(user: @user) }
      it 'dont change votes ' do
        expect{ patch :vote_up, params: {question_id: question, id: object} }.to_not change(object.votes, :count)
      end

      it 'error 422' do
        patch :vote_up, params: { question_id: question, id: object }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PATCH #vote_down' do
    login_user
    context ' noauthor try to vote down' do
      context 'user already has vote' do
        before { create(:vote, :down, user: @user, votable: object) }

        it 'dont change votes' do
          expect{ patch :vote_down, params: { question_id: question, id: object} }.to_not change(object.votes, :count)
        end

        it 'render error' do
          patch :vote_down, params: { question_id: question, id: object }
          expect(response.body).to eq 'You already voted'
        end

        it 'error 422' do
          patch :vote_down, params: { question_id: question, id: object }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'resource author try to vote down' do
      before { object.update(user: @user) }


      it 'dont change votes ' do
        expect{ patch :vote_down, params: {quesiton_id: question, id: object} }.to_not change(object.votes, :count)
      end

      it 'error 422' do
        patch :vote_down, params: { question_id: question, id: object}
        expect(response).to have_http_status(422)
      end
    end
  end
end
