require 'rails_helper'

RSpec.describe Like, type: :model do
  # ###################################################################
  # define main test object attrs
  # ###################################################################
  let(:test_all) {
    {user_id: 1, post_id: 1}
  }


  # ###################################################################
  # define standard create/update attr variations
  # ###################################################################
  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {user_id: 2, post_id: 2}
  }
  
  # every attr blank
  let(:blank) {
    {user_id: "", post_id: ""}
  }


  # ###################################################################
  # define custom error messages
  # ###################################################################
  let(:missing_user_message) {"You must provide a user."}
  let(:missing_post_message) {"You must provide a post."}
  let(:update_user_message) {"Can't change the user."}
  let(:update_post_message) {"Can't change the post."}
  let(:dupe_like_message) {"You already liked that post."}

  
  # ###################################################################
  # define tests
  # ###################################################################
  before(:all) do
    DatabaseCleaner.clean_with(:truncation)

    user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    post1 = Post.create(content: "This is post1; it's from user 1.", user_id: 1)
  end

  describe "model creates and updates only valid instances" do
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Like.all.count).to eq(0)

        test_like = Like.create(test_all)
        
        expect(test_like).to be_valid
        expect(Like.all.count).to eq(1)
        expect(test_like.user_id).to eq(test_all[:user_id])
        expect(test_like.post_id).to eq(test_all[:post_id])
      end
    end
    
    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Like.all.count).to eq(0)

        test_like = Like.create(blank)

        expect(test_like).to be_invalid
        expect(Like.all.count).to eq(0)
        expect(test_like.errors.messages[:user_id]).to include(missing_user_message)
        expect(test_like.errors.messages[:post_id]).to include(missing_post_message)
      end

      it "tries to update user or post" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Like.all.count).to eq(0)

        test_like = Like.create(test_all)
        expect(Like.all.count).to eq(1)

        test_like.update(update)

        expect(test_like).to be_invalid
        expect(test_like.errors.messages[:user_id]).to include(update_user_message)
        expect(test_like.errors.messages[:post_id]).to include(update_post_message)
      end

      it "tries to like a post that's already liked" do
        expect(User.all.count).to eq(1)
        expect(Post.all.count).to eq(1)
        expect(Like.all.count).to eq(0)

        user = User.first
        post = Post.first
        like = user.likes.create(post: post)
        expect(Like.all.count).to eq(1)

        # actual result tested - uses check_post_already_liked method
        test_like = user.likes.create(post: post)

        expect(test_like).to be_invalid
        expect(test_like.errors.messages[:user_id]).to include(dupe_like_message)
        expect(test_like.errors.messages[:post_id]).to include(dupe_like_message)
      end
    end
  end
  
  describe "instances are properly associated to User and Post models" do
    it "can find the user that created it and the post it's for" do
      user = User.first
      post = Post.first
      test_like = Like.create(test_all)
      expect(User.all.count).to eq(1)
      expect(Post.all.count).to eq(1)
      expect(Like.all.count).to eq(1)

      # actual methods being tested
      expect(test_like.user).to eq(user)
      expect(test_like.post).to eq(post)
    end
  end
end
