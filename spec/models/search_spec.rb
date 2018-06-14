require 'rails_helper'

RSpec.describe Search do
  describe '.search' do
    %w(Questions Answers Comments Users).each do |resource|
      it "Array of #{resource}" do
        expect(ThinkingSphinx).to receive(:search).with('Search text', classes: [resource.singularize.classify.constantize])
        Search.query('Search text', "#{resource}")
      end

      it "Anything" do
        expect(ThinkingSphinx).to receive(:search).with('Search text')
        Search.query('Search text', 'Anything')
      end
    end
  end
end
