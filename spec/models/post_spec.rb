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
    DatabaseCleaner.clean_with(:truncation)

    user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
    user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
    user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
  end

  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(0)
        
        test_post = Post.create(test_all)
        
        expect(test_post).to be_valid
        expect(Post.all.count).to eq(1)
        expect(test_post.content).to eq(test_all[:content])
        expect(test_post.user_id).to eq(test_all[:user_id])
      end

      it "updating all attributes with valid values" do
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
        expect(User.all.count).to eq(3)
        expect(Post.all.count).to eq(0)

        test_post = Post.create(blank)

        expect(test_post).to be_invalid
        expect(Post.all.count).to eq(0)
        expect(test_post.errors.messages[:content]).to include(missing_content_message)
        expect(test_post.errors.messages[:user_id]).to include(missing_user_message)
      end

      it "tries to update user" do
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

    it "knows how long ago (from now) it was created" do 
      now =    DateTime.new(2022, 3,  8,  11, 10, 45)
      day =    DateTime.new(2022, 3,  3,  12, 15, 45)
      week =   DateTime.new(2022, 2,  28, 13, 20, 45)
      week2 =  DateTime.new(2022, 2,  22, 14, 25, 45)
      month =  DateTime.new(2022, 2,  6,  15, 30, 45)
      month2 = DateTime.new(2022, 1,  7,  15, 30, 45)
      cross =  DateTime.new(2021, 12, 8,  16, 35, 45)
      year =   DateTime.new(2021, 3,  8,  17, 40, 45)
      year2 =  DateTime.new(2020, 3,  8,  18, 45, 45)      
      hour =   DateTime.new(2022, 3,  8,  10, 10, 45)
      hour2 =  DateTime.new(2022, 3,  8,  9,  10, 45)
      min =    DateTime.new(2022, 3,  8,  11, 9,  45)
      min2 =   DateTime.new(2022, 3,  8,  11, 5,  45)
      min3 =   DateTime.new(2022, 3,  8,  10, 20, 45)
      sec =    DateTime.new(2022, 3,  8,  11, 10, 00)
      sec2 =   DateTime.new(2022, 3,  8,  11, 9,  55)

      day_msg =    "5 days ago"
      week_msg =   "8 days ago"
      week2_msg =  "2 weeks ago"
      month_msg =  "1 month ago"
      month2_msg = "2 months ago"
      cross_msg =  "3 months ago"
      year_msg =   "1 year ago"
      year2_msg =  "2 years ago"
      hour_msg =   "1 hour ago"
      hour2_msg =  "2 hours ago"
      min_msg =    "1 minute ago"
      min2_msg =   "5 minutes ago"
      min3_msg =   "50 minutes ago"
      sec_msg =    "seconds ago"
      sec2_msg =   "seconds ago"

      post = Post.create(test_all)
      post.update(created_at: now)
      expect(post.created_at).to eq(now)

      # #### begin actual testing #########
      post.update(created_at: day)
      expect(post.time_since_creation).to eq(day_msg)

      post.update(created_at: week)
      expect(post.time_since_creation).to eq(week_msg)

      post.update(created_at: week2)
      expect(post.time_since_creation).to eq(week2_msg)

      post.update(created_at: month)
      expect(post.time_since_creation).to eq(month_msg)

      post.update(created_at: month2)
      expect(post.time_since_creation).to eq(month2_msg)

      post.update(created_at: cross)
      expect(post.time_since_creation).to eq(cross_msg)

      post.update(created_at: year)
      expect(post.time_since_creation).to eq(year_msg)

      post.update(created_at: year2)
      expect(post.time_since_creation).to eq(year2_msg)

      post.update(created_at: hour)
      expect(post.time_since_creation).to eq(hour_msg)

      post.update(created_at: hour2)
      expect(post.time_since_creation).to eq(hour2_msg)

      post.update(created_at: min)
      expect(post.time_since_creation).to eq(min_msg)

      post.update(created_at: min2)
      expect(post.time_since_creation).to eq(min2_msg)

      post.update(created_at: min3)
      expect(post.time_since_creation).to eq(min3_msg)

      post.update(created_at: sec)
      expect(post.time_since_creation).to eq(sec_msg)

      post.update(created_at: sec2)
      expect(post.time_since_creation).to eq(sec2_msg)
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
      post1 = user.posts.create(test_all)
      post2 = user.posts.create(update)

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

    it "upon destruction, it also deletes all associated comments" do
      user = User.first
      post1 = user.posts.create(test_all)
      post2 = user.posts.create(update)

      comment1 = user.comments.create(content: "first comment on post 1", post: post1)
      comment2 = user.comments.create(content: "second comment on post 1", post: post1)
      comment3 = user.comments.create(content: "first comment on post 2", post: post2)
      expect(Comment.all.count).to eq(3)

      post1.destroy
      expect(Post.exists?(post1.id)).to eq(false)
      expect(Comment.exists?(comment1.id)).to eq(false)
      expect(Comment.exists?(comment2.id)).to eq(false)
      expect(Comment.exists?(comment3.id)).to eq(true)
    end
    
    it "can find all likes on post" do
      user1 = User.first
      user2 = User.second
      post1 = user1.posts.create(test_all)
      post2 = user1.posts.create(update)

      like1 = user1.likes.create(post: post1)
      like2 = user1.likes.create(post: post2)
      like3 = user2.likes.create(post: post2)
      expect(Like.all.count).to eq(3)
      
      expect(post1.likes).to include(like1)
      expect(post1.likes).to_not include(like2)
      expect(post1.likes).to_not include(like3)

      expect(post2.likes).to_not include(like1)
      expect(post2.likes).to include(like2)
      expect(post2.likes).to include(like3)
    end

    it "upon destruction, it also deletes all associated likes" do
      user1 = User.first
      user2 = User.second
      post1 = user1.posts.create(test_all)
      post2 = user1.posts.create(update)

      like1 = user1.likes.create(post: post1)
      like2 = user1.likes.create(post: post2)
      like3 = user2.likes.create(post: post1)
      like4 = user2.likes.create(post: post2)
      expect(Like.all.count).to eq(4)

      post1.destroy
      expect(Post.exists?(post1.id)).to eq(false)
      expect(Like.exists?(like1.id)).to eq(false)
      expect(Like.exists?(like2.id)).to eq(true)
      expect(Like.exists?(like3.id)).to eq(false)
      expect(Like.exists?(like4.id)).to eq(true)
    end
  end
end
