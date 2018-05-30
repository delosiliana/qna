shared_examples_for 'API List' do
  it 'returns list of object' do
    expect(response.body).to have_json_size(2).at_path(object)
  end
end
