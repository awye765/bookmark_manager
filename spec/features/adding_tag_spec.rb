feature 'Adding a tag' do

  scenario 'User can add a tag to a link' do
    add_link_one_tag
    link = Link.first
    expect(link.tags.map(&:name)).to include('education')
  end

  scenario 'I can add multiple tags to a new link' do
    add_link_two_tags
    link = Link.first
    expect(link.tags.map(&:name)).to include('education', 'ruby')
  end
end
