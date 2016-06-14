feature "Tagging links" do
  scenario "can add a tag to a link" do
    fill_in_title_and_url
    fill_in(:tags, with: "code")
    click_button("Submit")

    link = Link.first
    expect(link.tags.map(&:name)).to include("code")
  end

  scenario "can add multiple tags to a new link" do
    visit '/links/new'
    fill_in 'url', with: 'http://www.makersacademy.com'
    fill_in 'title', with: 'Makers Academy'
    fill_in 'tags', with: 'education ruby'
    click_button 'Submit'
    link = Link.first_or_create
    expect(link.tags.map(&:name)).to include('education', 'ruby')
  end

end
