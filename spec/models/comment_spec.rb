require 'rails_helper'

RSpec.describe Comment, type: :model do
  # ###################################################################
  # define main test object attrs
  # ###################################################################
  let(:test_all) {
    {content: "This is a comment, or it's content, really.", user_id: 1, post_id: 1}
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
    {content: "This is a different comment."}
  }
  
  # every attr blank
  let(:blank) {
    {content: "", user_id: "", post_id: ""}
  }

  # ###################################################################
  # define custom error messages
  # ###################################################################
  let(:missing_content_message)  {"You must provide some content to your comment."}
  let(:missing_user_message) {"You must provide a user."}
  let(:missing_post_message) {"You must provide a user."}
  let(:update_user_message) {"Can't change the user of a comment."}
  let(:update_post_message) {"Can't change the post of a comment."}

  # ###################################################################
  # define tests
  # ###################################################################
  before(:all) do
    user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
    user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
    # user4 = User.create(first_name: "Jill", last_name: "Hill", username: "jillhill", email: "jillhill@example.com", password: "tester")
    # user5 = User.create(first_name: "John", last_name: "Doe", username: "johndoe", email: "johndoe@example.com", password: "tester")

    post1 = Post.create(content: "This is post1; it's from user 1.", user_id: 1)
    post2 = Post.create(content: "This is post2; it's from user 1.", user_id: 1)
    # post3 = Post.create(content: "This is post3; it's from user 2.", user_id: 2)
  end

  describe "model creates and updates only valid instances" do
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(2)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(test_all)

        expect(test_comment).to be_valid
        expect(Comment.all.count).to eq(1)
        expect(test_comment.content).to eq(test_all[:content])
        expect(test_comment.user_id).to eq(test_all[:user_id])
        expect(test_comment.post_id).to eq(test_all[:post_id])
      end

      it "updating all user-input attributes with valid values" do
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(2)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(test_all)
        expect(Comment.all.count).to eq(1)

        test_comment.update(update)

        expect(test_comment).to be_valid
        expect(test_comment.content).to eq(update[:content])
        expect(test_comment.user_id).to eq(test_all[:user_id])
        expect(test_comment.post_id).to eq(test_all[:post_id])
      end
    end

    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(2)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(blank)

        expect(test_comment).to be_invalid
        expect(Comment.all.count).to eq(0)
        expect(test_comment.errors.messages[:content]).to include(missing_content_message)
        expect(test_comment.errors.messages[:user_id]).to include(missing_user_message)
        expect(test_comment.errors.messages[:post_id]).to include(missing_post_message)
      end

      it "tries to update user or post" do
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(2)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(test_all)
        expect(Comment.all.count).to eq(1)

        test_comment.update(user_id: 2, post_id: 2)

        expect(test_comment).to be_invalid
        expect(test_comment.errors.messages[:user_id]).to include(update_user_message)
        expect(test_comment.errors.messages[:post_id]).to include(update_post_message)
      end

      # it "tries to update post" do
      #   expect(User.all.count).to eq(3)
      #   expect(Post.all.count).to eq(0)
      #   expect(Comment.all.count).to eq(0)
      # end
    end
  end

  describe "all helper methods work correctly:" do
    it "can remove beginning and trailing white space" do
      user = User.first
      post = Post.first
      expect(User.all.count).to eq(3)
      expect(Post.all.count).to eq(2)
      expect(Comment.all.count).to eq(0)

      bad_content = "   this has white space before, in the     middle, and after.   "

      # format_content should clean this up before validationg using .strip
      test_comment = Comment.create(content: bad_content, user_id: user.id, post_id: post.id)
      expect(Comment.all.count).to eq(1)
      expect(test_comment.user_id).to eq(user.id)
      expect(test_comment.post_id).to eq(post.id)

      # actual result to test
      expect(test_comment.content).to eq("this has white space before, in the     middle, and after.")
    end
  end

  describe "instances are properly associated to User model" do
    it "can find the user that created it" do
      expect(self).to eq("PENDING")
    end

    it "can collect all comments from a specific user"
      # hold on this - not sure if I really will use this anywhere
  end
  describe "instances are properly associated to Post model" do
    it "can find post it's for" do
      expect(self).to eq("PENDING")
    end

    it "can collect all comments for a specific post" do
      expect(self).to eq("PENDING")
    end
  end


end
