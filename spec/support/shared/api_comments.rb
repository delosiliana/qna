shared_examples_for 'API Commentable' do
  context 'comments' do
    it 'comments question object' do
      expect(response.body).to have_json_size(1).at_path("#{object}/comments")
    end

    %w(id body created_at updated_at user_id).each do |attr|
      it "question comment object contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{object}/comments/0/#{attr}")
      end
    end
  end
end
