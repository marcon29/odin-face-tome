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
    post3 = Post.create(content: "This is post3; it's from user 2.", user_id: 2)
  end

  describe "model creates and updates only valid instances" do
    describe "valid when " do
      it "given all required and unrequired valid attributes"
      it "updating all user-input attributes with valid values"
    end
    describe "invalid and has correct error message when" do
      it "required attributes are missing"
      it "tries to update user"
      it "tries to update post"
    end
  end
  describe "all helper methods work correctly:" do
    it "can remove beginning and trailing white space"
  end
  describe "instances are properly associated to User model" do
    it "can find the user that created it"
    it "can collect all comments from a specific user"
      # hold on this - not sure if I really will use this anywhere
  end
  describe "instances are properly associated to Post model" do
    it "can find post it's for"
    it "can collect all comments for a specific post"
  end


end
