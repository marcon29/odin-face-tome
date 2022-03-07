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
      password: "tester"
    }
  }
   
  # ###################################################################
  # define standard create/update attr variations
  # ###################################################################
  
  # exact duplicate of test_all
  # use as whole for testing unique values
  # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
  let(:duplicate) {
    {first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester"}
  }
  
  # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
  # let(:test_req) {
  #   {first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester"}
  # }

  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "testertester"}
  }
  
  # every attr blank
  let(:blank) {
    {first_name: "", last_name: "", username: "", email: "", password: ""}
  }

  # ###################################################################
  # define test results for auto-assign attrs
  # ###################################################################
  let(:default_request_status) {"pending"}
  let(:accepted_request_status) {"accepted"}
  let(:rejected_request_status) {"rejected"}

  # ###################################################################
  # define custom error messages
  # ###################################################################
  let(:missing_first_name_message) {"You must provide your first name."}
  let(:missing_last_name_message)  {"You must provide your last name."}
  let(:missing_username_message)   {"You must provide a username."}
  let(:missing_email_message)      {"You must provide your email."}
  let(:missing_password_message)   {"You must provide a password."}

  let(:duplicate_user_message)     {"That username is already used."}
  let(:duplicate_email_message)    {"That email is already used."}
  
  let(:format_username_message) {"Username can only use letters and numbers without spaces."}
  let(:format_email_message) {"Email doesn't look valid. Please use another."}
  let(:short_password_message) {"Password must be 6 characters or more."}

  
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
        expect(User.all.count).to eq(0)
        
        test_user = User.create(test_all)
        expect(test_user).to be_valid
        expect(User.all.count).to eq(1)
        
        expect(test_user.first_name).to eq(test_all[:first_name])
        expect(test_user.last_name).to eq(test_all[:last_name])
        expect(test_user.username).to eq(test_all[:username])
        expect(test_user.email).to eq(test_all[:email])
        expect(test_user.password).to eq(test_all[:password])
      end
      
      it "any attribute that can be duplicated is duplicated" do
        expect(User.all.count).to eq(0)

        duplicate[:username] = "diffusername"
        duplicate[:email] = "diff@example.com"
        
        test_user = User.create(duplicate)
        expect(test_user).to be_valid
        expect(User.all.count).to eq(1)

        expect(test_user.first_name).to eq(duplicate[:first_name])
        expect(test_user.last_name).to eq(duplicate[:last_name])
        expect(test_user.username).to eq(duplicate[:username])
        expect(test_user.email).to eq(duplicate[:email])
        expect(test_user.password).to eq(duplicate[:password])
      end

      it "updating all attributes with valid values" do
        expect(User.all.count).to eq(0)
              
        # create and check original instance
        test_user = User.create(duplicate)
        expect(test_user).to be_valid
        expect(User.all.count).to eq(1)
        
        # update all attrs, check all have new values for same instance
        test_user.update(update)
        expect(test_user).to be_valid
        
        # update input tests (should have value in update)
        expect(test_user.first_name).to eq(update[:first_name])
        expect(test_user.last_name).to eq(update[:last_name])
        expect(test_user.username).to eq(update[:username])
        expect(test_user.email).to eq(update[:email])
        expect(test_user.password).to eq(update[:password])
      end
    end
    
    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        expect(User.all.count).to eq(0)

        test_user = User.create(blank)

        expect(test_user).to be_invalid
        expect(User.all.count).to eq(0)
        
        # add tests as needed
        expect(test_user.errors.messages[:first_name]).to include(missing_first_name_message)
        expect(test_user.errors.messages[:last_name]).to include(missing_last_name_message)
        expect(test_user.errors.messages[:username]).to include(missing_username_message)
        expect(test_user.errors.messages[:email]).to include(missing_email_message)
        expect(test_user.errors.messages[:password]).to include(missing_password_message)
      end

      it "unique attributes are duplicated" do
        expect(User.all.count).to eq(0)
              
        # create and check original instance
        test_user = User.create(test_all)
        expect(test_user).to be_valid
        expect(User.all.count).to eq(1)
        
        # create new instance that duplicates a non-duplicable attr, check for failure
        dupe_user = User.create(duplicate)
        expect(dupe_user).to be_invalid
        expect(User.all.count).to eq(1)
        
        # check correct error message
        expect(dupe_user.errors.messages[:username]).to include(duplicate_user_message)
        expect(dupe_user.errors.messages[:email]).to include(duplicate_email_message)
      end
        
      it "username is outside allowable inputs" do
        # inserted spaces are autofixed
        bad_scenarios = ["ba$d%u$er", "bad.user!"]
                
        bad_scenarios.each do | test_value |
          duplicate[:username] = test_value
          user = User.create(duplicate)
          expect(user).to be_invalid
          expect(User.all.count).to eq(0)
          expect(user.errors.messages[:username]).to include(format_username_message)
        end
      end

      it "email is outside allowable inputs" do
        # has spaces (these are auto fixed), has double dot, missing local, missing domain, missing @, missing dot, missing extension, short extension, long extension, bad extension (number)
        bad_scenarios = ["joe.blow@example..com", "@example.com", "joe_blow@.com", "joe_blowexample.com", "joe_blow@examplecom", "joe_blow@example.", "joe_blow@example.c", "joe_blow@example.comm", "joe_blow@example.c2m"]
                
        bad_scenarios.each do | test_value |
          duplicate[:email] = test_value
          user = User.create(duplicate)
          expect(user).to be_invalid
          expect(User.all.count).to eq(0)
          expect(user.errors.messages[:email]).to include(format_email_message)
        end
      end

      it "password is too short" do
        duplicate[:password] = "test"
        test_user = User.create(duplicate)

        expect(test_user).to be_invalid
        expect(User.all.count).to eq(0)
        expect(test_user.errors.messages[:password]).to include(short_password_message)
      end
    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "formats names to init cap while executing validations" do
      duplicate[:first_name] = "some"
      duplicate[:last_name] = "tester"
      user = User.create(duplicate)
      
      expect(user.first_name).to eq("Some")
      expect(user.last_name).to eq("Tester")
    end
    
    it "can return the users's full name with correct capitalization" do
      duplicate[:first_name] = "some"
      duplicate[:last_name] = "tester"
      user = User.create(duplicate)

      expect(user.full_name).to eq("Some Tester")
    end


    it "formats username (no spaces, lowercase) while executing validations" do
      duplicate[:username] = "some tester name"
      user = User.create(duplicate)

      expect(user.username).to eq("sometestername")
    end


    it "formats email (no spaces, lowercase) while executing validations" do
      duplicate[:email] = "joe blow@ex ample.co m"
      user = User.create(duplicate)

      expect(user.email).to eq("joeblow@example.com")
    end
    
    
  end

  # association tests ########################################################
  describe "instances are properly associated to other users via Friend model" do
    before(:all) do
      user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
      user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
      user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
      user4 = User.create(first_name: "Jill", last_name: "Hill", username: "jillhill", email: "jillhill@example.com", password: "tester")
    end

    it "can initiate a friend request" do
      sender = User.first
      receiver = User.last

      # make this a method in model
      friend_request = sender.sent_friendship_requests.create(request_receiver: receiver)

      expect(friend_request).to eq(Friend.last)
      expect(friend_request.request_status).to eq(default_request_status)
    end
      
    it "can update a received request to accept it" do
      sender = User.first
      receiver = User.last      
      sender.sent_friendship_requests.create(request_receiver: receiver)
      
      # make this a method in model
      receiver.received_friendship_requests.first.update(request_status: "accepted")
      friend_request = sender.sent_friendship_requests.first

      expect(friend_request).to eq(Friend.last)
      expect(friend_request.request_status).to eq(accepted_request_status)
    end

    it "can update a received request to reject it" do
      sender = User.first
      receiver = User.last      
      sender.sent_friendship_requests.create(request_receiver: receiver)
      
      # make this a method in model
      receiver.received_friendship_requests.first.update(request_status: "rejected")
      friend_request = sender.sent_friendship_requests.first

      expect(friend_request).to eq(Friend.last)
      expect(friend_request.request_status).to eq(rejected_request_status)
    end

    it "can unfriend someone" do
      sender = User.first
      receiver = User.last      
      sender.sent_friendship_requests.create(request_receiver: receiver)

      # make this a method in model
      sender.sent_friendship_requests.first.destroy

      sender_friend = sender.sent_friendship_requests.first
      receiver_friend = receiver.received_friendship_requests.first

      expect(sender_friend).to be_nil
      expect(receiver_friend).to be_nil
    end
      
    it "can find all pending friend requests it initiated" do
      user = User.first
      receiver1 = User.second
      receiver2 = User.third
      receiver3 = User.last

      friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
      friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
      friend_request3 = user.sent_friendship_requests.create(request_receiver: receiver3)
      receiver1.received_friendship_requests.first.update(request_status: "accepted")

      # make this a method in model
      pending_sent_friend_requests = Friend.where(request_sender: user).where(request_status: "pending")
      
      expect(pending_sent_friend_requests).to_not include(friend_request1)
      expect(pending_sent_friend_requests).to include(friend_request2)
      expect(pending_sent_friend_requests).to include(friend_request3)
    end

    it "can find all pending friend requests it received" do
      user = User.first
      sender1 = User.second
      sender2 = User.third
      sender3 = User.last

      friend_request1 = sender1.sent_friendship_requests.create(request_receiver: user)
      friend_request2 = sender2.sent_friendship_requests.create(request_receiver: user)
      friend_request3 = sender3.sent_friendship_requests.create(request_receiver: user)
      user.received_friendship_requests.first.update(request_status: "accepted")

      # make this a method in model
      pending_received_friend_requests = Friend.where(request_receiver: user).where(request_status: "pending")
      
      expect(pending_received_friend_requests).to_not include(friend_request1)
      expect(pending_received_friend_requests).to include(friend_request2)
      expect(pending_received_friend_requests).to include(friend_request3)
    end


      
    it "can find all friends" do
      user = User.first
      receiver1 = User.second
      receiver2 = User.third
      sender1 = User.last

      friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
      friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
      friend_request3 = sender1.sent_friendship_requests.create(request_receiver: user)
      receiver1.received_friendship_requests.first.update(request_status: "rejected")
      receiver2.received_friendship_requests.first.update(request_status: "accepted")

      # make this a method in model
      friends = Friend.where(request_status: "accepted").and(
        Friend.where(request_sender: user).or(
          Friend.where(request_receiver: user)
        )
      )

      expect(friends).to_not include(friend_request1)
      expect(friends).to include(friend_request2)
      expect(friends).to_not include(friend_request3)
    end


      
  end

  describe "instances are properly associated to Post, Comment and Like models" do
    it "can create a new post"
      # self.posts.build
    it "can find all of it's own posts"
      # self.posts.where(user: current_user)
    it "can find all posts of friends"
      # self.posts.where(user: friend)
    it "can comment on a post"
      # self.comments.build
    it "can like a post"
      # self.likes.build
  end

  describe "destroys all associations or assoc instances when deleted" do
    it "upon destruction, it also deletes all likes"
      # self.destroy
      # self.likes.destroy
    it "upon destruction, it also deletes all comments"
      # self.destroy
      # self.comments.destroy    
    it "upon destruction, it also deletes all posts"
      # self.destroy
      # self.posts.destroy    
    it "upon destruction, it also deletes all friendships (but not friends)"
      # self.destroy
      # self.friendships.destroy
  end
end
