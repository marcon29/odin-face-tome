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
      password: "tester", 
      image_url: "fb_image.jpg", 
      oauth_default: true
    }
  }

  let(:pi_test_all) {
    {fit: "contain", position: "bottom", horiz_pos: nil, vert_pos: nil}
  }


   
  # ###################################################################
  # define standard create/update attr variations
  # ###################################################################
  
  # exact duplicate of test_all
  # use as whole for testing unique values
  # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
  let(:duplicate) {
    {first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester", image_url: "fb_image.jpg", oauth_default: true}
  }
  
  let(:pi_duplicate) {
    {fit: "contain", position: "bottom", horiz_pos: nil, vert_pos: nil}
  }
  
  # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
  let(:test_req) {
    {first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester"}
  }

  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "testertester", image_url: "fb_image_rev.jpg", oauth_default: false}
  }
  
  let(:pi_update) {
    {fit: "cover", position: "top", horiz_pos: 100, vert_pos: 100}
  }
  
  # every attr blank
  let(:blank) {
    {first_name: "", last_name: "", username: "", email: "", password: "", image_url: "", oauth_default: ""}
  }

  let(:pi_blank) {
    {fit: "", position: "", horiz_pos: "", vert_pos: ""}
  }

  # ###################################################################
  # define test results for auto-assign attrs
  # ###################################################################
  let(:default_request_status) {"pending"}
  let(:accepted_request_status) {"accepted"}
  let(:rejected_request_status) {"rejected"}
  let(:default_oauth_default) {false}
  
  let(:fallback_pi_filename) {"fallback-profile-img.png"}
  let(:fallback_pi_display_name) {"Facebook Profile Image"}
  let(:oauth_pi_display_name) {"Default User Icon"}
  

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
  let(:image_file_type_message) {"You may only upload .jpeg or .png files."}
  

  
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
        expect(test_user.image_url).to eq(test_all[:image_url])
        expect(test_user.oauth_default).to eq(test_all[:oauth_default])
      end

      it "given only required valid attributes" do
        expect(User.all.count).to eq(0)
        
        test_user = User.create(test_req)
        expect(test_user).to be_valid
        expect(User.all.count).to eq(1)
        
        # req attrs that should have values
        expect(test_user.first_name).to eq(test_req[:first_name])
        expect(test_user.last_name).to eq(test_req[:last_name])
        expect(test_user.username).to eq(test_req[:username])
        expect(test_user.email).to eq(test_req[:email])
        expect(test_user.password).to eq(test_req[:password])
        
        # unreq attrs that should NOT have values
        expect(test_user.image_url).to be_nil
        
        # unreq attrs with default fallbacks
        expect(test_user.oauth_default).to eq(default_oauth_default)
      end
      
      it "any attribute that can be duplicated is duplicated" do
        expect(User.all.count).to eq(0)

        # change all attrs that can't be duplicated
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
        expect(test_user.image_url).to eq(duplicate[:image_url])
        expect(test_user.oauth_default).to eq(duplicate[:oauth_default])
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
        expect(test_user.image_url).to eq(update[:image_url])
        expect(test_user.oauth_default).to eq(update[:oauth_default])
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
    it "can return the users's full name with correct capitalization" do
      duplicate[:first_name] = "some"
      duplicate[:last_name] = "tester"
      user = User.create(duplicate)

      expect(user.full_name).to eq("Some Tester")
    end

    it "formats names to init cap while executing validations" do
      duplicate[:first_name] = "some"
      duplicate[:last_name] = "tester"
      user = User.create(duplicate)
      
      expect(user.first_name).to eq("Some")
      expect(user.last_name).to eq("Tester")
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
      user5 = User.create(first_name: "John", last_name: "Doe", username: "johndoe", email: "johndoe@example.com", password: "tester")
    end

    after(:all) do
      DatabaseCleaner.clean_with(:truncation)
    end

    describe "executes friending processes correctly:" do
      it "can initiate and save a friend request" do
        # tests initialize_friend_request method
        sender = User.first
        receiver = User.last

        friend_request = sender.initialize_friend_request(receiver)
        expect(Friend.all.count).to eq(0)
        expect(sender.sent_friendship_requests).to include(friend_request)

        friend_request.save
        expect(Friend.all.count).to eq(1)
        expect(friend_request).to eq(Friend.last)
        expect(friend_request.request_status).to eq(default_request_status)
      end
        
      it "can accept a received request" do
        # tests decide_friend_request method (with accept as arg)
        sender = User.first
        receiver = User.last      
        sender.sent_friendship_requests.create(request_receiver: receiver)
        friend_request = sender.sent_friendship_requests.last
          expect(Friend.all.count).to eq(1)
          expect(friend_request.request_status).to eq(default_request_status)

        decided_request = receiver.decide_friend_request(sender, "accepted")
        decided_request.save
          expect(decided_request).to eq(Friend.last)
          expect(decided_request.request_status).to eq(accepted_request_status)
      end

      it "can reject a received request" do
        # tests decide_friend_request method (with reject as arg)
        sender = User.first
        receiver = User.last      
        sender.sent_friendship_requests.create(request_receiver: receiver)
        friend_request = sender.sent_friendship_requests.last
          expect(Friend.all.count).to eq(1)
          expect(friend_request.request_status).to eq(default_request_status)

        decided_request = receiver.decide_friend_request(sender, "rejected")
        decided_request.save
          expect(decided_request).to eq(Friend.last)
          expect(decided_request.request_status).to eq(rejected_request_status)
      end

      it "can unfriend or cancel a sent friend requst" do
        # tests cancel_friendship_or_request method

        user = User.first
        sender = User.second
        receiver = User.third
        user.sent_friendship_requests.create(request_receiver: receiver)
        sender.sent_friendship_requests.create(request_receiver: user)

        # cancels a friendship that user initiated
        user.cancel_friendship_or_request(receiver)
            user_sent_friend = user.sent_friendship_requests.first
            receiver_friend = receiver.received_friendship_requests.first
            expect(user_sent_friend).to be_nil
            expect(receiver_friend).to be_nil

        # cancels a friendship that user received
        user.cancel_friendship_or_request(sender)
            user_received_friend = user.received_friendship_requests.first
            sender_friend = sender.sent_friendship_requests.first
            expect(user_received_friend).to be_nil
            expect(sender_friend).to be_nil
      end
    end

    describe "finding friend requests (not users) and request statuses:" do
      it "can find friend request (regardless of status) sent to or received from a specific other user" do
        # tests find_friendship_or_request method
        user = User.first
        receiver1 = User.second
        sender1 = User.third
        sender2 = User.last
  
        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = sender1.sent_friendship_requests.create(request_receiver: user)
        friend_request3 = sender2.sent_friendship_requests.create(request_receiver: user)
        receiver1.received_friendship_requests.first.update(request_status: "rejected")
        user.received_friendship_requests.first.update(request_status: "accepted")
        
        # actual method being tested
        find1 = user.find_friendship_or_request(receiver1)
        find2 = user.find_friendship_or_request(sender1)
        find3 = user.find_friendship_or_request(sender2)
          expect(find1).to eq(friend_request1)
          expect(find2).to eq(friend_request2)
          expect(find3).to eq(friend_request3)
      end

              # !!!!!!!!!! COMMENTED OUT  in model - may not need
                      # did not reveiw with rest after image update - (if keeping - will need to be reviewed)
                  # it "can find all pending friend requests it initiated" do
                  #   user = User.first
                  #   receiver1 = User.second
                  #   receiver2 = User.third
                  #   receiver3 = User.last

                  #   friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
                  #   friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
                  #   friend_request3 = user.sent_friendship_requests.create(request_receiver: receiver3)
                  #   receiver1.received_friendship_requests.first.update(request_status: "accepted")
                    
                  #   # actual method being tested
                  #   requests = user.pending_sent_friend_requests
                    
                  #   expect(requests).to_not include(friend_request1)
                  #   expect(requests).to include(friend_request2)
                  #   expect(requests).to include(friend_request3)
                  # end

              # !!!!!!!!!! COMMENTED OUT  in model - may not need
                      # did not reveiw with rest after image update - (if keeping - will need to be reviewed)
                  # it "can find all pending friend requests it received" do
                  #   user = User.first
                  #   sender1 = User.second
                  #   sender2 = User.third
                  #   sender3 = User.last

                  #   friend_request1 = sender1.sent_friendship_requests.create(request_receiver: user)
                  #   friend_request2 = sender2.sent_friendship_requests.create(request_receiver: user)
                  #   friend_request3 = sender3.sent_friendship_requests.create(request_receiver: user)
                  #   user.received_friendship_requests.first.update(request_status: "accepted")

                  #   # actual method being tested
                  #   requests = user.pending_received_friend_requests
                    
                  #   expect(requests).to_not include(friend_request1)
                  #   expect(requests).to include(friend_request2)
                  #   expect(requests).to include(friend_request3)
                  # end

      it "can tell if a friend request (sender or reciver) with a specific other user has been rejected or not" do
        # tests rejected? method
        user = User.first
        receiver1 = User.second
        sender1 = User.third
        sender2 = User.last
  
        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = sender1.sent_friendship_requests.create(request_receiver: user)
        friend_request3 = sender2.sent_friendship_requests.create(request_receiver: user)
        receiver1.received_friendship_requests.first.update(request_status: "rejected")
        user.received_friendship_requests.first.update(request_status: "accepted")
        
        # actual method being tested (asks if user has been rejected)
          expect(user.rejected?(receiver1)).to eq(true)
          expect(user.rejected?(sender1)).to eq(false)
          expect(user.rejected?(sender2)).to eq(false)
      end
    end

    describe "finding the users of requests sent and received:" do
      it "can find all receivers of pending friend requests it initiated" do
        user = User.first
        receiver1 = User.second
        receiver2 = User.third
        receiver3 = User.last

        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
        friend_request3 = user.sent_friendship_requests.create(request_receiver: receiver3)
        receiver1.received_friendship_requests.first.update(request_status: "accepted")
        
        # actual method being tested
        friend_request_receivers = user.pending_request_receivers
        
        expect(friend_request_receivers).to_not include(receiver1)
        expect(friend_request_receivers).to include(receiver2)
        expect(friend_request_receivers).to include(receiver3)
      end

      it "can find all senders of pending friend requests it received" do
        user = User.first
        sender1 = User.second
        sender2 = User.third
        sender3 = User.last

        friend_request1 = sender1.sent_friendship_requests.create(request_receiver: user)
        friend_request2 = sender2.sent_friendship_requests.create(request_receiver: user)
        friend_request3 = sender3.sent_friendship_requests.create(request_receiver: user)
        user.received_friendship_requests.first.update(request_status: "accepted")

        # actual method being tested
        friend_request_senders = user.pending_request_senders
        
        expect(friend_request_senders).to_not include(sender1)
        expect(friend_request_senders).to include(sender2)
        expect(friend_request_senders).to include(sender3)
      end

      it "can collect all other users with pending requests (as sender or receiver)" do
        # tests pending_request_senders_and_receivers method
        user = User.first
        receiver1 = User.second
        receiver2 = User.third
        sender1 = User.fourth
        sender2 = User.last

        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
        friend_request3 = sender1.sent_friendship_requests.create(request_receiver: user)
        friend_request4 = sender2.sent_friendship_requests.create(request_receiver: user)
        receiver1.received_friendship_requests.first.update(request_status: "accepted")
        user.received_friendship_requests.first.update(request_status: "rejected")

        # actual method being tested
        expect(user.pending_request_senders_and_receivers).to_not include(receiver1)
        expect(user.pending_request_senders_and_receivers).to include(receiver2)
        expect(user.pending_request_senders_and_receivers).to_not include(sender1)
        expect(user.pending_request_senders_and_receivers).to include(sender2)
      end

      it "can collect all other users that are neither friend, request sender or request receiver" do
        # tests non_contacted_users method
        user = User.first
        friend = User.second
        sender = User.third
        receiver = User.fourth
        stranger = User.last

        friend_request1 = user.sent_friendship_requests.create(request_receiver: friend)
        friend_request2 = sender.sent_friendship_requests.create(request_receiver: user)
        friend_request3 = user.sent_friendship_requests.create(request_receiver: receiver)
        friend.received_friendship_requests.first.update(request_status: "accepted")

        # actual method being tested
        expect(user.non_contacted_users).to_not include(friend)
        expect(user.non_contacted_users).to_not include(sender)
        expect(user.non_contacted_users).to_not include(receiver)
        expect(user.non_contacted_users).to include(stranger)
      end
      
      it "can tell if a friendship has been initiated (not decided on) with another user or not" do
        user = User.first
        receiver1 = User.second
        receiver2 = User.third
        sender1 = User.last
  
        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
        friend_request3 = sender1.sent_friendship_requests.create(request_receiver: user)
        receiver1.received_friendship_requests.first.update(request_status: "rejected")
        receiver2.received_friendship_requests.first.update(request_status: "accepted")
  
        # actual method being tested
        expect(user.friendship_initiated?(receiver1)).to eq(false)
        expect(user.friendship_initiated?(receiver2)).to eq(false)
        expect(user.friendship_initiated?(sender1)).to eq(true)
      end
  
      it "can tell if another user is a friendship request receiver or not" do
        user = User.first
        receiver1 = User.second
        receiver2 = User.third
        sender1 = User.last      
  
        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
        friend_request3 = sender1.sent_friendship_requests.create(request_receiver: user)
        receiver1.received_friendship_requests.first.update(request_status: "rejected")
  
        # actual method being tested
        expect(user.request_receiver?(receiver1)).to eq(false)
        expect(user.request_receiver?(receiver2)).to eq(true)
        expect(user.request_receiver?(sender1)).to eq(false)
      end
  
      it "can tell if another user is a friendship request sender or not" do
        user = User.first
        receiver1 = User.second
        sender1 = User.third
        sender2 = User.last      
  
        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = sender1.sent_friendship_requests.create(request_receiver: user)
        friend_request3 = sender2.sent_friendship_requests.create(request_receiver: user)
        user.received_friendship_requests.first.update(request_status: "rejected")
  
        # actual method being tested
        expect(user.request_sender?(receiver1)).to eq(false)
        expect(user.request_sender?(sender1)).to eq(false)
        expect(user.request_sender?(sender2)).to eq(true)
      end
    end

    describe "finding the friends of current_user" do
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

        # actual method being tested
        user_friends = user.friends
        

        expect(user_friends).to_not include(receiver1)
        expect(user_friends).to include(receiver2)
        expect(user_friends).to_not include(sender1)
      end

      it "can tell if another user is a friend or not" do
        user = User.first
        receiver1 = User.second
        receiver2 = User.third
        sender1 = User.last

        friend_request1 = user.sent_friendship_requests.create(request_receiver: receiver1)
        friend_request2 = user.sent_friendship_requests.create(request_receiver: receiver2)
        friend_request3 = sender1.sent_friendship_requests.create(request_receiver: user)
        receiver1.received_friendship_requests.first.update(request_status: "rejected")
        receiver2.received_friendship_requests.first.update(request_status: "accepted")

        # actual method being tested
        expect(user.friend?(receiver1)).to eq(false)
        expect(user.friend?(receiver2)).to eq(true)
        expect(user.friend?(sender1)).to eq(false)
      end
    end
  end

  describe "instances are properly associated to and can control Profile Image" do
    before(:each) do
      DatabaseCleaner.clean_with(:truncation)

      @image_file1 = Rails.root.join('spec', 'support', 'assets', 'zeke-squirrel.jpg')
      @image_file2 = Rails.root.join('spec', 'support', 'assets', 'tick-icon.png')
      
      @upload1 = ActiveStorage::Blob.create_and_upload!(
        io: File.open(@image_file1, 'rb'),
        filename: 'zeke-squirrel.jpg',
        content_type: 'image/jpg'
      ).signed_id

      @upload2 = ActiveStorage::Blob.create_and_upload!(
        io: File.open(@image_file2, 'rb'),
        filename: 'tick-icon.png',
        content_type: 'image/png'
      ).signed_id
    end

    # after(:each) do
    #   DatabaseCleaner.clean_with(:truncation)
    # end

    it "can upload a new profile image" do
      expect(User.all.count).to eq(0)
      user = User.create(test_all)
      expect(user).to be_valid
      expect(User.all.count).to eq(1)

      blob = ActiveStorage::Blob.first
      user.profile_image.attach(blob)
      attachment = ActiveStorage::Attachment.first
        expect(user.profile_image.attachments).to include(attachment)
        expect(user.profile_image.id).to eq(blob.id)
        expect(user.profile_image.attachments).to eq(blob.attachments)
    end

    it "can upload a replacement profile image" do
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      blob1 = ActiveStorage::Blob.first
      user.profile_image.attach(blob1)
      expect(user.profile_image.id).to eq(blob1.id)
      
      blob2 = ActiveStorage::Blob.last
      user.profile_image.attach(blob2)
        expect(user.profile_image.id).to eq(blob2.id)
        expect(user.profile_image.attachments).to eq(blob2.attachments)
    end

    it "can delete its profile image" do
        # create user to manage everything
        user = User.create(test_all)
        expect(User.all.count).to eq(1)  
        
        # upload blob and create attachment
        blob = ActiveStorage::Blob.first
        user.profile_image.attach(blob)
        expect(ActiveStorage::Blob.all.count).to eq(2)
        expect(user.profile_image.id).to eq(blob.id)

        # find attachment to actually do the deletion process
        attachment = ActiveStorage::Attachment.find_by(record_id: user.id)
        expect(ActiveStorage::Attachment.all.count).to eq(1)
        expect(user.profile_image.attachments).to include(attachment)
        
        # delete and test
        attachment.purge
        user.reload
          expect(ActiveStorage::Blob.all.count).to eq(1)
          expect(ActiveStorage::Attachment.all.count).to eq(0)
          expect(user.profile_image.attachments).to be_nil
          expect(user.profile_image.id).to be_nil
    end

    it "can choose the correct profile image to display" do
      # tests get_profile_image method while switching between upload, Oauth, and default
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      # #### NO profile image upload (test with oauth true and false)
      user.update(oauth_default: true)
        expect(user.get_profile_image).to eq(user.image_url)

      user.update(oauth_default: false)
        expect(user.get_profile_image).to eq(fallback_pi_filename)
      
      # #### add profile image upload (test with oauth true and false)
      blob = ActiveStorage::Blob.first
      user.profile_image.attach(blob)
      user.update(oauth_default: true)
        expect(user.get_profile_image).to eq(user.image_url)
      
      user.update(oauth_default: false)
        expect(user.get_profile_image).to eq(user.profile_image)
    end

    it "can update blob to have all positioning data for the uploaded image" do
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      blob = ActiveStorage::Blob.first
      user.profile_image.attach(blob)
      expect(user.profile_image.id).to eq(blob.id)
      
      user.profile_image.update(pi_test_all)
        expect(user.profile_image.fit).to eq(pi_test_all[:fit])
        expect(user.profile_image.position).to eq(pi_test_all[:position])
        expect(user.profile_image.horiz_pos).to eq(pi_test_all[:horiz_pos])
        expect(user.profile_image.vert_pos).to eq(pi_test_all[:vert_pos])
    end

    it "can gather all uploaded image positioning data into hash" do
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      blob = ActiveStorage::Blob.first
      user.profile_image.attach(blob)
      expect(user.profile_image.id).to eq(blob.id)
      
      # actual method being tested, should return hash of all positioning data
      user.profile_image.update(pi_test_all)
      pos_data = user.collect_image_positioning_data
        expect(pos_data[:obj_fit]).to eq(pi_test_all[:fit])
        expect(pos_data[:obj_pos]).to eq(pi_test_all[:position])
        expect(pos_data[:obj_vert]).to eq(pi_test_all[:horiz_pos])
        expect(pos_data[:obj_horiz]).to eq(pi_test_all[:vert_pos])
    end

    it "if no upload image, gathering all the positioning data returns nil" do
      # needs to be nil, not an empty array
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      expect(user.collect_image_positioning_data).to be_nil
    end

    it "if upload image but positioning data not set, gathering all data returns nil" do
      # needs to be nil, not an empty array
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      blob = ActiveStorage::Blob.first
      user.profile_image.attach(blob)
      expect(user.profile_image.id).to eq(blob.id)

      expect(user.collect_image_positioning_data).to be_nil
    end

    it "an uploaded image must be a jpg or png file" do
      # create user to control everything
      user = User.create(test_all)
      expect(User.all.count).to eq(1)

      # upload bad test files (pdf, video, audio, text, gif)
      bad_image_file1 = Rails.root.join('spec', 'support', 'bad_assets', 'bad_audio_file.mp3')
      bad_image_file2 = Rails.root.join('spec', 'support', 'bad_assets', 'bad_pdf_file.pdf')
      bad_image_file3 = Rails.root.join('spec', 'support', 'bad_assets', 'bad_text_file.txt')
      bad_image_file4 = Rails.root.join('spec', 'support', 'bad_assets', 'bad_video_file.mp4')
      bad_image_file5 = Rails.root.join('spec', 'support', 'bad_assets', 'bad_webp_gif_file.webp')
      
      # deliberately putting bad or missing content_type values to make sure can't fake validation (these should autocorrect)
      bad_upload1 = ActiveStorage::Blob.create_and_upload!(io: File.open(bad_image_file1, 'rb'), filename: 'bad_audio_file.mp3', content_type: 'image/jpg').signed_id
      bad_upload2 = ActiveStorage::Blob.create_and_upload!(io: File.open(bad_image_file2, 'rb'), filename: 'bad_pdf_file.pdf', content_type: 'image/jpg').signed_id
      bad_upload3 = ActiveStorage::Blob.create_and_upload!(io: File.open(bad_image_file3, 'rb'), filename: 'bad_text_file.txt').signed_id
      bad_upload4 = ActiveStorage::Blob.create_and_upload!(io: File.open(bad_image_file4, 'rb'), filename: 'bad_video_file.mp4', content_type: 'image/jpg').signed_id
      bad_upload5 = ActiveStorage::Blob.create_and_upload!(io: File.open(bad_image_file5, 'rb'), filename: 'bad_webp_gif_file.webp', content_type: 'image/jpg').signed_id
        expect(ActiveStorage::Blob.all.count).to eq(7)
        expect(ActiveStorage::Attachment.all.count).to eq(0)
      
      # so we did all that to test these:
      user.profile_image.attach(bad_upload1)
      user.reload
        expect(user.profile_image).to be_blank
        expect(user.profile_image.attached?).to eq(false)
        expect(ActiveStorage::Attachment.all.count).to eq(0)
        expect(user.profile_image.filename).to be_nil
        expect(user.errors.messages[:profile_image]).to include(image_file_type_message)

      user.profile_image.attach(bad_upload2)
      user.reload
        expect(user.profile_image).to be_blank
        expect(user.profile_image.attached?).to eq(false)
        expect(ActiveStorage::Attachment.all.count).to eq(0)
        expect(user.profile_image.filename).to be_nil
        expect(user.errors.messages[:profile_image]).to include(image_file_type_message)

      user.profile_image.attach(bad_upload3)
      user.reload
        expect(user.profile_image).to be_blank
        expect(user.profile_image.attached?).to eq(false)
        expect(ActiveStorage::Attachment.all.count).to eq(0)
        expect(user.profile_image.filename).to be_nil
        expect(user.errors.messages[:profile_image]).to include(image_file_type_message)

      user.profile_image.attach(bad_upload4)
      user.reload
        expect(user.profile_image).to be_blank
        expect(user.profile_image.attached?).to eq(false)
        expect(ActiveStorage::Attachment.all.count).to eq(0)
        expect(user.profile_image.filename).to be_nil
        expect(user.errors.messages[:profile_image]).to include(image_file_type_message)

      user.profile_image.attach(bad_upload5)
      user.reload
        expect(user.profile_image).to be_blank
        expect(user.profile_image.attached?).to eq(false)
        expect(ActiveStorage::Attachment.all.count).to eq(0)
        expect(user.profile_image.filename).to be_nil
        expect(user.errors.messages[:profile_image]).to include(image_file_type_message)
    end

    it "when uploading an image, oauth_default is set to false if valid upload" do
      # create user to control everything (ensure has image_url and oauth_default is true)
      user = User.create(test_all)
      good_blob = ActiveStorage::Blob.first
      expect(User.all.count).to eq(1)
      expect(ActiveStorage::Blob.all.count).to eq(2)
      expect(user.profile_image.attached?).to eq(false)
      expect(user.image_url).to eq(test_all[:image_url])
      expect(user.oauth_default).to eq(true)

      # create GOOD AS::attachment via user
      user.profile_image.attach(good_blob)
      user.reload
      expect(user.profile_image.attached?).to eq(true)
      expect(user.profile_image.id).to eq(good_blob.id)
      expect(user.image_url).to eq(test_all[:image_url])

      # actucal test (good upload)
        expect(user.oauth_default).to eq(false)
    end

    it "when uploading an image, oauth_default remains true if upload is invalid" do
      user = User.create(test_all)
      bad_image_file1 = Rails.root.join('spec', 'support', 'bad_assets', 'bad_audio_file.mp3')
      bad_upload1 = ActiveStorage::Blob.create_and_upload!(io: File.open(bad_image_file1, 'rb'), filename: 'bad_audio_file.mp3', content_type: 'image/jpg').signed_id

      bad_blob = ActiveStorage::Blob.last
      expect(User.all.count).to eq(1)
      expect(ActiveStorage::Blob.all.count).to eq(3)
      expect(user.profile_image.attached?).to eq(false)
      expect(user.image_url).to eq(test_all[:image_url])
      expect(user.oauth_default).to eq(true)

      # create BAD AS::attachment via user
      user.profile_image.attach(bad_blob)
      user.reload
      expect(user.profile_image.attached?).to eq(false)
      expect(user.image_url).to eq(test_all[:image_url])

      # actucal test (bad upload)
        expect(user.oauth_default).to eq(true)
    end

    it "when changing upload position without changing image, oauth_default remains true (if set that way)" do
      user = User.create(update)
      good_blob = ActiveStorage::Blob.first
      user.profile_image.attach(good_blob)
      user.update(oauth_default: true)

      expect(User.all.count).to eq(1)
      expect(ActiveStorage::Blob.all.count).to eq(2)
      expect(user.profile_image.attached?).to eq(true)
      expect(user.image_url).to eq(update[:image_url])
      expect(user.oauth_default).to eq(true)

       # update profile image positioning via user
       user.profile_image.update(pi_test_all)
       expect(user.profile_image.attached?).to eq(true)
       expect(user.image_url).to eq(update[:image_url])
       expect(user.profile_image.fit).to eq(pi_test_all[:fit])
       
       # actucal test (good upload)
       expect(user.oauth_default).to eq(true)
    end

    it "if no oauth image stored, oauth_default is auto set to false during validation" do
      # user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")

      # test auto set at instantiation (with or without oauth image)
        # create reg user (instantiate with no image_url, no arg passed for oauth_default)
        # create oauth user (instantiate with image_url, no arg passed for oauth_default)
        reg_user = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
        oauth_user = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester", image_url: "fb_image.jpg")
        expect(User.all.count).to eq(2)
        expect(reg_user.image_url).to be_blank
        expect(oauth_user.image_url).to eq(test_all[:image_url])
          # test reg_user.oauth_default is set to false  (want app to function this way - change app, not test if fails)
          # test oauth_user.oauth_default is set to true (want app to function this way - change app, not test if fails)
          expect(reg_user.oauth_default).to eq(false)
          expect(oauth_user.oauth_default).to eq(true)

      # test updating oauth_default (with or without oauth image)
        # update reg user for ouath_default set to true
        # update oauth user for ouath_default set to false
        reg_user.update(oauth_default: true)
        oauth_user.update(oauth_default: false)
        expect(reg_user.image_url).to be_blank
        expect(oauth_user.image_url).to eq(test_all[:image_url])
          # test reg_user.oauth_default switches back to false
          # test oauth_user.oauth_default switches to false
          expect(reg_user.oauth_default).to eq(false)
          expect(oauth_user.oauth_default).to eq(false)

      # reset ouath_user to run remainging tests
        # update oauth user for ouath_default set to true
        oauth_user.update(oauth_default: true)
        expect(reg_user.image_url).to be_blank
        expect(oauth_user.image_url).to eq(test_all[:image_url])
          # test oauth_user.oauth_default switches to true
          expect(oauth_user.oauth_default).to eq(true)

      # test oauth_default changes with oauth image added/deleted (try to force bad default value)
        # update reg user to set image_url, keep ouath_default set to false (pass in as false)
        # update oauth user to delete image_url, keep ouath_default set to true (pass in as true)
        reg_user.update(image_url: "fb_image_rev.jpg", oauth_default: false)
        oauth_user.update(image_url: nil, oauth_default: true)
        expect(reg_user.image_url).to eq(update[:image_url])
        expect(oauth_user.image_url).to be_blank
          # test reg_user.oauth_default remains false (because with image_url, can do whatever he wants)
          # test oauth_user.oauth_default switches to false
          expect(reg_user.oauth_default).to eq(false)
          expect(oauth_user.oauth_default).to eq(false)

      # update reg user for ouath_default set to true
      # update oauth user for ouath_default set to true
      reg_user.update(oauth_default: true)
      oauth_user.update(oauth_default: true)
      expect(reg_user.image_url).to eq(update[:image_url])
      expect(oauth_user.image_url).to be_blank
        # test reg_user.oauth_default is now true
        # test reg_user.oauth_default switches back to false
        expect(reg_user.oauth_default).to eq(true)
        expect(oauth_user.oauth_default).to eq(false)
    end
  end

  describe "instances are properly associated to Post, Comment and Like models" do
    it "can create a new post" do
      # user.posts.build(comment: "built via user")
    end

    it "can find all of it's own posts" do
      # self.posts.where(user: current_user)
    end

    it "can find all posts of friends" do
      # self.posts.where(user: friend)
    end

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
