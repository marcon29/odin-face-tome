require 'rails_helper'

RSpec.describe Friend, type: :model do
  # ###################################################################
  # define main test object attrs
  # ###################################################################
  let(:test_all) {
    {
      request_sender_id: 1, 
      request_receiver_id: 2, 
      request_status: "pending"
    }
  }

   
  # ###################################################################
  # define standard create/update attr variations
  # ###################################################################
  
  # exact duplicate of test_all
  # use as whole for testing unique values
  # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
  let(:duplicate) {
    {request_sender_id: 1, request_receiver_id: 2, request_status: "pending"}
  }

  let(:reverse_duplicate) {
    {request_sender_id: 2, request_receiver_id: 1, request_status: "pending"}
  }

  let(:both_duplicate) {
    {request_sender_id: 1, request_receiver_id: 1, request_status: "pending"}
  }
  
  # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
  let(:test_req) {
    {request_sender_id: 1, request_receiver_id: 2}
  }

  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {request_sender_id: 3, request_receiver_id: 4, request_status: "accepted"}
  }
  
  # every attr blank
  let(:blank) {
    {request_sender_id: "", request_receiver_id: "", request_status: ""}
  }


  # ###################################################################
  # define test results for auto-assign attrs
  # ###################################################################
  let(:default_request_status) {"pending"}


  # ###################################################################
  # define custom error messages
  # ###################################################################
  let(:missing_request_sender_message) {"You must provide a request sender."}
  let(:missing_request_receiver_message)  {"You must provide a request receiver."}
  let(:missing_request_status_message)  {"You must provide a request status."}

  let(:duplicate_request_pair_message)  {"You two are already friends."}
  let(:duplicate_request_role_message)  {"You can't be friends with yourself."}
  
  let(:inclusion_request_status_message) {"Can only be pending, accepted, or rejected."}
  let(:update_request_role_message) {"Can't change a friend request."}
  
  
  # ###################################################################
  # define tests
  # ###################################################################
   
  # object creation and validation tests #######################################
   describe "model creates and updates only valid instances" do
    before(:all) do
      user1 = User.create(first_name: "Joe", last_name: "Schmo", username: "jschmo", email: "jschmo@example.com", password: "tester")
      user2 = User.create(first_name: "Jack", last_name: "Hill", username: "jhill", email: "jhill@example.com", password: "tester")
    end
    
    describe "valid when " do
      it "given all required and unrequired valid attributes" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)
        
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)
        
        expect(test_friend.request_sender_id).to eq(test_all[:request_sender_id])
        expect(test_friend.request_receiver_id).to eq(test_all[:request_receiver_id])
        expect(test_friend.request_status).to eq(test_all[:request_status])
      end

      it "given only required valid attributes" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)
        
        test_friend = Friend.create(test_req)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)
        
        expect(test_friend.request_sender_id).to eq(test_req[:request_sender_id])
        expect(test_friend.request_receiver_id).to eq(test_req[:request_receiver_id])
        expect(test_friend.request_status).to eq(default_request_status)
      end

      it "any attribute that can be duplicated is duplicated" do
        # set up tests (need two more users)
        user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
        user4 = User.create(first_name: "Jill", last_name: "Hill", username: "jillhill", email: "jillhill@example.com", password: "tester")
        expect(User.all.count).to eq(4)
        expect(Friend.all.count).to eq(0)
        
        # create friend to compare duplication
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)

        # create friend with same receiver (2) but different sender (1 vs. 3) - should be valid
        duplicate[:request_sender_id] = 3
        dupe_receiver = Friend.create(duplicate)
        expect(dupe_receiver).to be_valid
        expect(dupe_receiver.request_sender_id).to eq(duplicate[:request_sender_id])
        expect(dupe_receiver.request_receiver_id).to eq(duplicate[:request_receiver_id])
        expect(dupe_receiver.request_status).to eq(duplicate[:request_status])

        # create friend with same sender (3) but different receiver (2 vs. 4) - should be valid
        duplicate[:request_receiver_id] = 4
        dupe_sender = Friend.create(duplicate)
        expect(dupe_sender).to be_valid
        expect(dupe_sender.request_sender_id).to eq(duplicate[:request_sender_id])
        expect(dupe_sender.request_receiver_id).to eq(duplicate[:request_receiver_id])
        expect(dupe_sender.request_status).to eq(duplicate[:request_status])
      end

      it "updating all attributes with valid values" do
        # this test should only check if status updates
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)
        
        # create and check original instance
        test_friend = Friend.create(duplicate)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)
         
        # update all attrs, check all have new values for same instance
        test_friend.update(request_status: update[:request_status])
        expect(test_friend).to be_valid
        
        expect(test_friend.request_sender_id).to eq(duplicate[:request_sender_id])
        expect(test_friend.request_receiver_id).to eq(duplicate[:request_receiver_id])
        expect(test_friend.request_status).to eq(update[:request_status])
      end
    end
    
    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)

        test_friend = Friend.create(blank)

        expect(test_friend).to be_invalid
        expect(Friend.all.count).to eq(0)

        # add tests as needed
        expect(test_friend.errors.messages[:request_sender_id]).to include(missing_request_sender_message)
        expect(test_friend.errors.messages[:request_receiver_id]).to include(missing_request_receiver_message)
      end

      it "request sender and receiver pair are duplicated as same sender/receiver roles" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)

        # create and check original instance
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)

        # create new instance that duplicates both sender and reciever (in same roles)
        dupe_friend = Friend.create(duplicate)
        expect(dupe_friend).to be_invalid
        expect(Friend.all.count).to eq(1)
        expect(dupe_friend.errors.messages[:request_sender_id]).to include(duplicate_request_pair_message)
        expect(dupe_friend.errors.messages[:request_receiver_id]).to include(duplicate_request_pair_message)
      end

      it "request sender and receiver pair are duplicated as reversed sender/receiver roles" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)

        # create and check original instance
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)
        
        # create new instance that duplicates both sender and reciever (but reverses roles)
        rev_dupe_friend = Friend.create(reverse_duplicate)
        expect(rev_dupe_friend).to be_invalid
        expect(Friend.all.count).to eq(1)
        expect(rev_dupe_friend.errors.messages[:request_sender_id]).to include(duplicate_request_pair_message)
        expect(rev_dupe_friend.errors.messages[:request_receiver_id]).to include(duplicate_request_pair_message)
      end

      it "request sender and receiver are the same" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)

        # create and check original instance
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)

        # create new instance that duplicates both sender and reciever (in same roles)
        dupe_friend = Friend.create(both_duplicate)
        expect(dupe_friend).to be_invalid
        expect(Friend.all.count).to eq(1)
        expect(dupe_friend.errors.messages[:request_sender_id]).to include(duplicate_request_role_message)
        expect(dupe_friend.errors.messages[:request_receiver_id]).to include(duplicate_request_role_message)
      end

      it "request_status is outside allowable inputs" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)
        
        duplicate[:request_status] = "bad data"
        test_friend = Friend.create(duplicate)
        
        expect(test_friend).to be_invalid
        expect(Friend.all.count).to eq(0)
        expect(test_friend.errors.messages[:request_status]).to include(inclusion_request_status_message)
      end

      it "trys to update when missing request_status" do
        expect(User.all.count).to eq(2)
        expect(Friend.all.count).to eq(0)

        # create and check original instance
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)

        update[:request_status] = ""
        test_friend.update(request_status: update[:request_status])
        expect(test_friend).to be_invalid
        expect(test_friend.errors.messages[:request_status]).to include(missing_request_status_message)

        update[:request_status] = nil
        test_friend.update(request_status: update[:request_status])
        expect(test_friend).to be_invalid
        expect(test_friend.errors.messages[:request_status]).to include(missing_request_status_message)
      end

      it "trys to update request sender or receiver" do
        user3 = User.create(first_name: "Jane", last_name: "Doe", username: "janedoe", email: "janedoe@example.com", password: "tester")
        user4 = User.create(first_name: "Jill", last_name: "Hill", username: "jillhill", email: "jillhill@example.com", password: "tester")
        expect(User.all.count).to eq(4)
        expect(Friend.all.count).to eq(0)

        # create and check original instance
        test_friend = Friend.create(test_all)
        expect(test_friend).to be_valid
        expect(Friend.all.count).to eq(1)
        
        test_friend.update(update)
        expect(test_friend.errors.messages[:request_sender_id]).to include(update_request_role_message)
        expect(test_friend.errors.messages[:request_receiver_id]).to include(update_request_role_message)
      end
    end
  end
  
end
