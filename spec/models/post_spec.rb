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
  before(:all) do
    user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
    user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
    # user4 = User.create(first_name: "Jill", last_name: "Hill", username: "jillhill", email: "jillhill@example.com", password: "tester")
    # user5 = User.create(first_name: "John", last_name: "Doe", username: "johndoe", email: "johndoe@example.com", password: "tester")
  end

  after(:all) do
    # DatabaseCleaner.clean_with(:truncation)
  end
  
  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        # test w/ test_all
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(0)
        
        test_post = Post.create(test_all)
        
        expect(test_post).to be_valid
        expect(Post.all.count).to eq(1)
        expect(test_post.content).to eq(test_all[:content])
        expect(test_post.user_id).to eq(test_all[:user_id])
      end

      it "updating all attributes with valid values" do
        # test w/ update
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(0)
        
        test_post = Post.create(test_all)
        expect(Post.all.count).to eq(1)
        
        test_post.update(update)

        expect(test_post).to be_valid
        expect(test_post.content).to eq(update[:content])
        expect(test_post.user_id).to eq(test_all[:user_id])
      end
    end

    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        # test w/ blank
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(0)

        test_post = Post.create(blank)

        expect(test_post).to be_invalid
        expect(Post.all.count).to eq(0)
        expect(test_post.errors.messages[:content]).to include(missing_content_message)
        expect(test_post.errors.messages[:user_id]).to include(missing_user_message)
      end

      it "tries to update user" do
        # grab this one from Friend tests
        expect(User.all.count).to eq(3)
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
      expect(User.all.count).to eq(3)
      expect(Post.all.count).to eq(0)

      bad_content = "   this has white space before, in the     middle, and after.   "

      # format_content should clean this up before validationg using .strip
      test_post = Post.create(content: bad_content, user_id: user.id)
      expect(Post.all.count).to eq(1)
      expect(test_post.user_id).to eq(user.id)

      # actual result to test
      expect(test_post.content).to eq("this has white space before, in the     middle, and after.")
    end

  end

  # association tests ########################################################
  describe "instances are properly associated to User model" do
    it "can find the user that created it" do
      user = User.first
      test_post = Post.create(test_all)
      expect(User.all.count).to eq(3)
      expect(Post.all.count).to eq(1)

      expect(test_post.user).to eq(user)
    end

    it "can collect all posts from a specific user" do
      expect(User.all.count).to eq(3)
      user1 = User.first
      user2 = User.second

      post1 = user1.posts.create(content: "first post from user 1.")
      post2 = user1.posts.create(content: "second post from user 1.")
      post3 = user2.posts.create(content: "first post from user 2.")
      expect(Post.all.count).to eq(3)

      # actual method being tested
      user1_post_collection = Post.all_by_user(user1)
      user2_post_collection = Post.all_by_user(user2)

      expect(user1_post_collection).to include(post1)
      expect(user1_post_collection).to include(post2)
      expect(user1_post_collection).to_not include(post3)

      expect(user2_post_collection).to_not include(post1)
      expect(user2_post_collection).to_not include(post2)
      expect(user2_post_collection).to include(post3)
    end
        
    it "can collect all posts from a collection of users" do
      expect(User.all.count).to eq(3)
      user1 = User.first
      user2 = User.second
      user3 = User.third
      user_collection = [user1, user2]

      post1 = user1.posts.create(content: "first post from user 1.")
      post2 = user1.posts.create(content: "second post from user 1.")
      post3 = user2.posts.create(content: "first post from user 2.")
      post4 = user2.posts.create(content: "second post from user 2.")
      post5 = user3.posts.create(content: "first post from user 3.")
      post6 = user3.posts.create(content: "second post from user 3.")
      expect(Post.all.count).to eq(6)

      # actual method being tested
      test_post_collection = Post.all_by_user_collection(user_collection)

      expect(test_post_collection).to include(post1)
      expect(test_post_collection).to include(post2)
      expect(test_post_collection).to include(post3)
      expect(test_post_collection).to include(post4)
      expect(test_post_collection).to_not include(post5)
      expect(test_post_collection).to_not include(post6)
    end
  end

  describe "instances are properly associated to Comment and Like models" do
    it "can find all comments on post" do
      user = User.first
      post1 = Post.first
      post2 = Post.second

      comment1 = user.comments.create(content: "first comment on post 1", post: post1)
      comment2 = user.comments.create(content: "second comment on post 1", post: post1)
      comment3 = user.comments.create(content: "first comment on post 2", post: post2)
      expect(Comment.all.count).to eq(3)
      
      expect(post1.comments).to include(comment1)
      expect(post1.comments).to include(comment2)
      expect(post1.comments).to_not include(comment3)

      expect(post2.comments).to_not include(comment1)
      expect(post2.comments).to_not include(comment2)
      expect(post2.comments).to include(comment3)
    end

    it "can find all users that commented on post" 
      # hold on this - not sure if I really will use this anywhere  
      # expect(self).to eq("PENDING")
    
    it "can count how many comments it has" 
      # hold - this is probably a pointless method (post.comments_count vs. post.comments.count)
      # create if need to change scope or something
     
    
    
    it "can find all likes on post"
      # expect(self.likes).to eq("PENDING")
    it "can find all users that liked post"
      # expect(self).to eq("PENDING")
    it "can count how many likes it has"
      # expect(self.likes_count).to eq("PENDING")
      # hold - this is probably a pointless method (post.likes_count vs. post.likes.count)
      # create if need to change scope or something
  end
      
  


  
end
