require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    it 'return http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    %w(Questions Answers Comments Users Anything).each do |context|
      it "search for resource: #{context}" do
        expect(Search).to receive(:query).with('Ask', context)
        get :index, params: { query: 'Ask', context: context }
      end

      it 'renders index template' do
        get :index, params: { query: 'Ask', resource: 'Anything' }
        expect(response).to render_template :index
      end
    end
  end
end
