feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'requires an email' do
    expect { sign_up(email: nil)}.not_to change(User, :count)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'requires a valid email input' do
    expect { sign_up(email: "invalid@email") }.not_to change(User, :count)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Email has an invalid format'
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect { sign_up }.to_not change(User, :count)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User sign in' do
  let!(:user) do
    User.create(email: 'user@example.com',
                password: 'secret1234',
                password_confirmation: 'secret1234')
  end

  scenario 'with correct credentials' do
    sign_in(email: user.email, password: user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end

feature 'User sign out' do
  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'while being signed in' do
    sign_in(email: 'test@test.com',
            password: 'test')
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, test@test.com')
  end

end

feature "Resetting Password" do

  before do
    sign_up
    Capybara.reset!
  end

  let!(:user) { User.first }

  scenario "When I forget my password I can see a alink to reset" do
    visit '/sessions/new'
    click_link "I'm an idiot and forgot my password"
    expect(page).to have_content("Please enter your email address")
  end

  scenario "When I enter my email I am told to check my inbox" do
    recover_password
    expect(page).to have_content "Thanks, please check your inbox for the link"
  end

  scenario "user assigned a reset token when they recover their password" do
    expect{ recover_password }.to change{ User.first.password_token }
  end

  scenario "it doesn't allow you to use the token after an hour" do
    recover_password
    Timecop.travel(60 * 60 * 60) do
      visit("/users/reset_password?token=#{user.password_token}")
      expect(page).to have_content "Your token is invalid"
    end
  end

  scenario "it asks for your new password when your token is valid" do
    recover_password
    visit("/users/reset_password?token=#{user.password_token}")
    expect(page).to have_content "Please enter your new password"
  end

  scenario "it lets you enter a new password with a valid token" do
    recover_password
    visit("/users/reset_password?token=#{user.password_token}")
    fill_in :password, with: "newpassword"
    fill_in :password_confirmation, with: "newpassword"
    click_button "Submit"
    expect(page).to have_content("Please sign in")
  end

  scenario "it lets you know if your passwords don't match" do
    recover_password
    visit("/users/reset_password?token=#{user.password_token}")
    fill_in :password, with: "newpassword"
    fill_in :password_confirmation, with: "wrongpassword"
    click_button "Submit"
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario 'it immediately resets token upon successful password update' do
    recover_password
    set_password(password: "newpassword", password_confirmation: "newpassword")
    visit("/users/reset_password?token=#{user.password_token}")
    expect(page).to have_content("Your token is invalid")
  end

  def set_password(password:, password_confirmation:)
    visit("/users/reset_password?token=#{user.password_token}")
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button "Submit"
  end

end

feature "Password recovery link" do
  let!(:user) do
    User.create(email: 'user@example.com',
                password: 'secret1234',
                password_confirmation: 'secret1234')
  end
  
  before do
     sign_up
     Capybara.reset!
     allow(SendRecoverLink).to receive(:call)
   end

  scenario 'it calls the SendRecoverLink service to send the link' do

    expect(SendRecoverLink).to receive(:call).with(user)
    recover_password
  end

end
