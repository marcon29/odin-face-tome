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
  let(:missing_post_message) {"You must provide a post."}
  let(:update_user_message) {"Can't change the user."}
  let(:update_post_message) {"Can't change the post."}


  # ###################################################################
  # define tests
  # ###################################################################
  before(:all) do
    DatabaseCleaner.clean_with(:truncation)

    user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    post1 = Post.create(content: "This is post1; it's from user 1.", user_id: 1)
    # post2 = Post.create(content: "This is post2; it's from user 1.", user_id: 1)
  end

  describe "model creates and updates only valid instances" do
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(test_all)

        expect(test_comment).to be_valid
        expect(Comment.all.count).to eq(1)
        expect(test_comment.content).to eq(test_all[:content])
        expect(test_comment.user_id).to eq(test_all[:user_id])
        expect(test_comment.post_id).to eq(test_all[:post_id])
      end

      it "updating all user-input attributes with valid values" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
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
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(blank)

        expect(test_comment).to be_invalid
        expect(Comment.all.count).to eq(0)
        expect(test_comment.errors.messages[:content]).to include(missing_content_message)
        expect(test_comment.errors.messages[:user_id]).to include(missing_user_message)
        expect(test_comment.errors.messages[:post_id]).to include(missing_post_message)
      end

      it "tries to update user or post" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Comment.all.count).to eq(0)

        test_comment = Comment.create(test_all)
        expect(Comment.all.count).to eq(1)

        test_comment.update(user_id: 2, post_id: 2)

        expect(test_comment).to be_invalid
        expect(test_comment.errors.messages[:user_id]).to include(update_user_message)
        expect(test_comment.errors.messages[:post_id]).to include(update_post_message)
      end
    end
  end

  describe "all helper methods work correctly:" do
    it "can remove beginning and trailing white space" do
      user = User.first
      post = Post.first
      expect(User.all.count).to eq(1)
      expect(Post.all.count).to eq(1)
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

  describe "instances are properly associated to User and Post models" do
    it "can find the user that created it and the post it's for" do
      user = User.first
      post = Post.first
      test_comment = Comment.create(test_all)
      expect(User.all.count).to eq(1)
      expect(Post.all.count).to eq(1)
      expect(Comment.all.count).to eq(1)

      # actual methods being tested
      expect(test_comment.user).to eq(user)
      expect(test_comment.post).to eq(post)
    end

    # it "can collect all comments for a specific post" do
    #   user = User.first
    #   post1 = Post.first
    #   post2 = Post.second

    #   comment1 = user.comments.create(content: "first comment on post 1", post: post1)
    #   comment2 = user.comments.create(content: "second comment on post 1", post: post1)
    #   comment3 = user.comments.create(content: "first comment on post 2", post: post2)
    #   expect(Comment.all.count).to eq(3)

    #   # actual method being tested
    #   post1_comment_collection = Comment.all_by_post(post1)
    #   post2_comment_collection = Comment.all_by_post(post2)

    #   expect(post1_comment_collection).to include(comment1)
    #   expect(post1_comment_collection).to include(comment2)
    #   expect(post1_comment_collection).to_not include(comment3)

    #   expect(post2_comment_collection).to_not include(comment1)
    #   expect(post2_comment_collection).to_not include(comment2)
    #   expect(post2_comment_collection).to include(comment3)
    # end
  end
end
