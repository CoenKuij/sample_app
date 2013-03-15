include ApplicationHelper 

def fill_in_valid_info
  fill_in "Name",         with: "Example User"
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def valid_signin(user)
  visit signin_path 
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token  
end

def invalid_sign_in 
	click_button "Sign in"
end

def sign_out
	click_link "Sign out"
end

def visit_another_page
	click_link "Home"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :show_signin_page do 
  match do |page|
    page.should have_selector('h1',    text: 'Sign in')
    page.should have_selector('title', text: 'Sign in')
  end
end

RSpec::Matchers.define :show_signout_link do 
  match do |page|
    page.should have_link('Sign out', href: signout_path)
  end
end

RSpec::Matchers.define :show_signin_link do 
  match do |page|
    page.should have_link('Sign in', href: signin_path)
  end
end

RSpec::Matchers.define :show_profile_page do |user|
	match do  |page|
		page.should have_selector('title', text: user.name) 
		page.should have_link('Profile', href: user_path(user))
	end
end

RSpec::Matchers.define :show_signup_page do 
  match do |page|
    page.should have_selector('h1',    text: 'Sign up')
    page.should have_selector('title', text: full_title('Sign up'))
  end
end

