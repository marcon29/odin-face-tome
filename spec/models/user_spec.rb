require 'rails_helper'

RSpec.describe User, type: :model do
  # ###################################################################
  # define main test object attrs
  # ###################################################################
  let(:test_all) {
    {
      first_name: "Joe", 
      last_name: "Schmo", 
      username: "jschmo", 
      email: "jschmo@example.com", 
      password: "test"
    }
  }
   
  # ###################################################################
  # define standard create/update attr variations
  # ###################################################################
  
  # exact duplicate of test_all
  # use as whole for testing unique values
  # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
  let(:duplicate) {
    {first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "test"}
  }
  
  # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
  # let(:test_req) {
  #   {first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "test"}
  # }

  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "test"}
  }
  
  # every attr blank
  let(:blank) {
    {first_name: "", last_name: "", username: "", email: "", password: ""}
  }

  # ###################################################################
  # define test results for auto-assign attrs
  # ###################################################################
  # let(:default_primary) {false}
  # let(:default_active) {true}

  # ###################################################################
  # define tests
  # ###################################################################
  
  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    # before(:each) do
    #     # insert some helper method here if need to
    # end
    
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
      end
      
      it "any attribute that can be duplicated is duplicated" do
      end

      it "updating all attributes with valid values" do
      end
    end
    
    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
      end

      it "unique attributes are duplicated" do
        # username, email
      end
        
      it "username is outside allowable inputs" do
        # username - contains anything other than letters or numbers
        # username - shorter than 6 characters (after formatting)
      end

      it "email is outside allowable inputs" do
        # has spaces, has double dot, missing local, missing @, missing dot, missing extension, short extension, long extension, bad extension (number)
      end
    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "formats names to init cap while executing validations" do
    end

    it "creates a full name while executing validations" do
    end

    it "formats username (no spaces, lowercase) while executing validations" do
    end

    it "formats email (no spaces, lowercase) while executing validations" do
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other users via Friend model" do
    it "can initiate a friend request" do
      # self.friends.build
    end

    it "can update a friend request to accept or reject it" do
      # self.friends.update
    end

    it "can unfriend someone" do
      # self.friends.destroy
    end

    it "can find all pending friend requests it initiated" do
      # self.initiated_friendships
    end

    it "can find all pending friend requests it received" do
      # self.accepted_friendships
    end

    it "can find all friends" do
      # self.friends
    end
  end

  describe "instances are properly associated to Post, Comment and Like models" do
    it "can create a new post" do
      # self.posts.build
    end

    it "can find all of it's own posts" do
      # self.posts.where(user: current_user)
    end

    it "can find all posts of friends" do
      # self.posts.where(user: friend)
    end

    it "can comment on a post" do
      # self.comments.build
    end

    it "can like a post" do
      # self.likes.build
    end
  end

  describe "destroys all associations or assoc instances when deleted" do
    it "upon destruction, it also deletes all likes" do
      # self.destroy
      # self.likes.destroy
    end

    it "upon destruction, it also deletes all comments" do
      # self.destroy
      # self.comments.destroy
    end
    
    it "upon destruction, it also deletes all posts" do
      # self.destroy
      # self.posts.destroy
    end
    
    it "upon destruction, it also deletes all friendships (but not friends)" do
      # self.destroy
      # self.friendships.destroy
    end
  end
end
