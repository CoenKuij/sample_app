require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
      valid_signin user
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.content)
      end
    end

    describe "should show the proper micropost count 2 post2" do
      it { should have_selector('span', text: '2 microposts') }
    end

    describe "should show the proper micropost count 1 post" do
      before { click_link "delete" }
      it { should have_selector('span', text: '1 micropost') }
    end
  end  

  describe "pagination" do
    let(:user) { FactoryGirl.create(:user) }
    before(:all) do
      32.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      valid_signin user
      visit root_path
    end

    after(:all) { User.delete_all }

    it { should have_selector('div.pagination') }
  end    
end