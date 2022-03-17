require 'rails_helper'

RSpec.describe Post, type: :model do
  # ###################################################################
  # define main test object attrs
  # ###################################################################
  let(:test_all) {
    {content: "This is content for a post. It's great.", user_id: 1}
  }
   
  # ###################################################################
  # define standard create/update attr variations
  # ###################################################################
  # exact duplicate of test_all
  # use as whole for testing unique values
  # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
  # let(:duplicate) {
  #   {content: "This is content for a post. It's great.", user_id: 1}
  # }

  # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
  # let(:test_req) {
  #   {content: "This is content for a post. It's great."}
  # }

  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {content: "This is updated content for a post. It's also great."}
  }
  
  # every attr blank
  let(:blank) {
    {content: "", user_id: ""}
  }

  # ###################################################################
  # define custom error messages
  # ###################################################################
  let(:missing_content_message)  {"You must provide some content to post."}
  let(:missing_user_message) {"You must provide a user."}
  let(:update_user_message) {"Can't change the user of a post."}
  


  # ###################################################################
  # define tests
  # ###################################################################
  
  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    before(:all) do
      user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    end
    
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        # test w/ test_all
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(0)
        
        test_post = Post.create(test_all)
        expect(test_post).to be_valid
        expect(Post.all.count).to eq(1)
        
        expect(test_post.content).to eq(test_all[:content])
        expect(test_post.user_id).to eq(test_all[:user_id])
      end
        

      it "updating all attributes with valid values" do
        # test w/ update
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(0)
        
        test_post = Post.create(test_all)
        expect(test_post).to be_valid
        expect(Post.all.count).to eq(1)

        # update all attrs, check all have new values for same instance
        test_post.update(update)

        expect(test_post).to be_valid
        expect(test_post.content).to eq(update[:content])
        expect(test_post.user_id).to eq(test_all[:user_id])
      end

    end

    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        # test w/ blank
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(0)

        test_post = Post.create(blank)

        expect(test_post).to be_invalid
        expect(Post.all.count).to eq(0)

        # add tests as needed
        expect(test_post.errors.messages[:content]).to include(missing_content_message)
        expect(test_post.errors.messages[:user_id]).to include(missing_user_message)
      end

      it "tries to update user" do
        # grab this one from Friend tests
        user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
        expect(User.all.count).to eq(2)
        expect(Post.all.count).to eq(0)

        test_post = Post.create(test_all)
        expect(test_post).to be_valid
        expect(Post.all.count).to eq(1)

        test_post.update(user_id: 2)
        expect(test_post).to be_invalid
        expect(test_post.content).to eq(test_all[:content])
        expect(test_post.errors.messages[:user_id]).to include(update_user_message)
      end

    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "can remove beginning and trailing white space" do
      user = User.first
      expect(User.all.count).to eq(1)
      expect(Post.all.count).to eq(0)

      bad_content = "   this has white space before, in the     middle, and after.   "

      # format_content should clean this up before validationg using .strip
      
      # test_post = Post.create(content: bad_content, user: user)
      test_post = Post.create(content: bad_content, user_id: user.id)
      
      expect(test_post).to be_valid
      expect(Post.all.count).to eq(1)
      expect(test_post.content).to eq("this has white space before, in the     middle, and after.")
      expect(test_post.user_id).to eq(user.id)
    end

  end

  # association tests ########################################################
  before(:all) do
    # user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    # user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
    # user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
    # user4 = User.create(first_name: "Jill", last_name: "Hill", username: "jillhill", email: "jillhill@example.com", password: "tester")
    # user5 = User.create(first_name: "John", last_name: "Doe", username: "johndoe", email: "johndoe@example.com", password: "tester")
  end

  after(:all) do
    # DatabaseCleaner.clean_with(:truncation)
  end

  describe "instances are properly associated to User model" do
    it "can find the user that created it"
      # post.user

    it "can collect all posts from a specific user"
      # user.posts??? this is a User function, maybe - posts_by_user(user)
        # would I ever call post.posts_by_user
        # class methdo?? Post.by_user(user)
        
    it "can collect all posts from a collection of users"
      # User function??, maybe - by_user_collection(collection)
        # would I ever call post.by_user_collection
        # class methdo?? Post.by_user_collection(collection)

  end

  describe "instances are properly associated to Comment and Like models" do
    it "can find all comments on post"
      # post.comments

    it "can count how many comments it has"
      # post.comments_count => post.comments.count
    
    it "can find all users that commented on post"

    it "can find all likes on post"
      # post.likes
      # likes don't have any content - need this (it will simply return a list of user_ids?

    it "can count how many likes it has"
      # post.likes_count => post.likes.count

    it "can find all users that liked post"
    
  end
      
  


  
end
