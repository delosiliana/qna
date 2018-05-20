require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  login_user
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: @user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    login_user

    before { get :edit, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to redirect_to root_url
    end
  end

  describe 'GET #new' do
    login_user

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save a question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    before { question }

    context 'author  tries to delete answer' do
      let(:question) { create(:question, user: @user) }

      it 'author delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'no author  tries to delete question' do
      let!(:another_user) { create(:user) }
      let!(:question) { create(:question, user: another_user)}

      it 'can not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    let(:question) { create :question, user: @user }

    context 'valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'redirects to the updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil }, format: :js } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 're-renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #vote_up' do
    login_user
    context 'non author try to vote up' do
      context 'user already has vote' do
        before { create(:vote, :up, user: @user, votable: question) }

        it 'dont chanhe votes' do
          expect{ patch :vote_up, params: { id:question} }.to_not change(question.votes, :count)
        end

        it 'render error' do
          patch :vote_up, params: { id:question }
          expect(response.body).to eq 'You already voted'
        end

        it 'response error 422' do
          patch :vote_up, params: { id:question }
          expect(response).to have_http_status(422)
        end
      end
    end
    context 'author try to vote up' do
      before { question.update(user: @user) }

      it 'dont change votes' do
        expect{ patch :vote_up, params: { id:question } }.to_not change(question.votes, :count)
      end

      it 'response error 422' do
        patch :vote_up, params: { id:question }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PATCH #vote_down' do
    login_user
    context 'noauthor try to vote down' do
      context 'user already has vote' do
        before { create(:vote, :down, user: @user, votable: question) }

        it 'dont change votes' do
          expect{ patch :vote_down, params: { id:question } }.to_not change(question.votes, :count)
        end

        it 'render error' do
          patch :vote_down, params: { id:question }
          expect(response.body).to eq 'You already voted'
        end

        it 'error 422' do
          patch :vote_down, params: { id:question }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'author try to vote down' do
      before { question.update(user: @user) }

      it 'dont chanhe votes' do
        expect{ patch :vote_down, params: { id: question } }.to_not change(question.votes, :count)
      end

      it 'error 422' do
        patch :vote_down, params: { id: question }
        expect(response).to have_http_status(422)
      end
    end
  end
end
