require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: user) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'questions object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token ) }
      let(:params) { { format: :json, access_token: access_token.token, question: attributes_for(:question) } }

      before { post '/api/v1/questions/', params: params }

      it_behaves_like 'API Status 200'

      it 'new question add to database' do
        expect{ post '/api/v1/questions/', params: params }.to change { Question.count }.by(1)
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { question: attributes_for(:question), format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question, user: user)}

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'attachments' do
        it 'attachment include question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w(url).each do |attr|
          it "question attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'comments question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "question comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end
end
