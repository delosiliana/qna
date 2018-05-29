require 'rails_helper'

describe 'Answers API' do
  let!(:user) { @user || create(:user) }
  let!(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }
  let!(:comment) { create(:comment, commentable: answer, user: user) }
  let!(:attachment) { create(:attachment, attachable: answer) }
  let!(:object) { "answers" }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'
      it_behaves_like 'API List'

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:params) { { action: :create, format: :json, access_token: access_token.token, answer: attributes_for(:answer) } }
      before { post "/api/v1/questions/#{question.id}/answers", params: params }

      it_behaves_like 'API Status 200'

      it 'saves new answer database' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: params }.to change(question.answers, :count).by(1)
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:object) { "answer"}

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'
      it_behaves_like 'API Attachable'

      %w(body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'comments answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at).each do |attr|
          it "answer comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end
end
