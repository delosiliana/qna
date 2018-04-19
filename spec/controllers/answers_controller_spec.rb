require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) {create(:answer, user: user, question: question) }
  let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }

  describe 'POST #create' do
    login_user
    let(:params) { { answer: attributes_for(:answer), question_id: question, format: :js } }

    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'the answer belongs to user' do
        expect { post :create, params: params }.to change(@user.answers, :count).by(1)
      end

      it 'render template create' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context 'with no valid attributes' do
      it 'doesnt save the answer' do
        expect { post :create, params: invalid_params }.to_not change(Answer, :count)
      end

      it 'render template create' do
        post :create, params: invalid_params
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    login_user
    let!(:answer) { create(:answer, question: question) }
    let!(:answer_author) { create(:answer, question: question, user: @user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer_author, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer_author
    end

    it 'assigns  the question' do
      patch :update, params: { id: answer_author, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer_author, answer: { body: 'new body' },question_id: question, format: :js }
      answer_author.reload
      expect(answer_author.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer_author, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    login_user

    let!(:answer) { create(:answer, question: question) }
    let!(:author_answer) { create(:answer, question: question, user: @user) }

    context 'author delete answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: author_answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: author_answer, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'no author  tries to delete answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #best' do
    login_user
    let(:question_user) { create :question, answers: create_list(:answer, 2), user: @user }
    let(:question) { create :question, answers: create_list(:answer, 2) }

    context 'Author set best answer for question'do
      it 'set best to true' do
        patch :best, params: { id: question_user.answers.first, format: :js }

        expect(assigns(:answer)).to be_best
      end

      it 'renders best template' do
        patch :best, params: { id: question.answers.first, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'no author try to set best answer of question' do
      it 'best is not set' do
        patch :best, params: { id: question.answers.first, format: :js }
        expect(assigns(:answer).best).to eq false
      end
    end
  end

  describe 'PATCH #vote_up' do
    login_user
    let(:answer) { create(:answer) }
    context 'noauthor try to vote up' do
      context 'user already has vote' do
        before do
          create(:vote, :up, user: @user, votable: answer)
          answer.update(question: question)
        end

        it 'dont chanhe votes' do
          expect{ patch :vote_up, params: { question_id: question, id: answer } }.to_not change(answer.votes, :count)
        end

        it 'render error' do
          patch :vote_up, params: { question_id: question, id: answer }
          expect(response.body).to eq 'You already voted'
        end

        it 'error 422' do
          patch :vote_up, params: { question_id: question, id: answer }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'answer author try to vote up' do
      before { answer.update(user: @user, question: question) }
      it 'dont chanhe votes ' do
        expect{ patch :vote_up, params: {question_id: question, id: answer} }.to_not change(answer.votes, :count)
      end

      it 'error 422' do
        patch :vote_up, params: { question_id: question, id: answer }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PATCH #vote_down' do
    login_user
    let(:answer) { create(:answer) }
    context ' noauthor try to vote down' do
      context 'user already has vote' do
        before do
          create(:vote, :down, user: @user, votable: answer)
          answer.update(question: question)
        end

        it 'dont chanhe votes' do
          expect{ patch :vote_down, params: { question_id: question, id: answer} }.to_not change(answer.votes, :count)
        end

        it 'render error' do
          patch :vote_down, params: { question_id: question, id: answer }
          expect(response.body).to eq 'You already voted'
        end

        it 'error 422' do
          patch :vote_down, params: { question_id: question, id: answer }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'answer author try to vote down' do
      before { answer.update(user: @user, question: question) }

      it 'dont chanhe votes ' do
        expect{ patch :vote_down, params: {quesiton_id: question, id: answer} }.to_not change(answer.votes, :count)
      end

      it 'error 422' do
        patch :vote_down, params: { question_id: question, id: answer}
        expect(response).to have_http_status(422)
      end
    end
  end
end
