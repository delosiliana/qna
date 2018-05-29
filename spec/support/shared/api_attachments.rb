shared_examples_for 'API Attachable' do
  context 'attachments' do
    it 'attachment include resource object' do
      expect(response.body).to have_json_size(1).at_path("#{object}/attachments")
    end

    %w(url).each do |attr|
      it "object resource attachment object contains #{attr}" do
        expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("#{object}/attachments/0/#{attr}")
      end
    end
  end
end
