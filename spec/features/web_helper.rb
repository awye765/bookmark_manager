def add_link_one_tag
  visit('/links/new')
  fill_in :url, with: 'www.makersacademy.com'
  fill_in :title, with: 'Makers Academy'
  fill_in :tags, with: 'education'
  click_button 'Add Link'
end

def add_link_two_tags
  visit('/links/new')
  fill_in :url, with: 'www.makersacademy.com'
  fill_in :title, with: 'Makers Academy'
  fill_in :tags, with: 'education ruby'
  click_button 'Add Link'
end

def recover_password
  visit '/users/recover'
  fill_in :email, with: "alice@example.com"
  click_button "Submit"
end
