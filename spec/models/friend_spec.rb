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

  let(:both_duplicate) {
    {request_sender_id: 1, request_receiver_id: 2, request_status: "pending"}
  }

  let(:reverse_duplicate) {
    {request_sender_id: 2, request_receiver_id: 1, request_status: "pending"}
  }
  
  # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
  let(:test_req) {
    {request_sender_id: 1, request_receiver_id: 2}
  }

  # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
  let(:update) {
    {request_status: "accepted"}
  }
  
  # every attr blank
  let(:blank) {
    {request_sender_id: "", request_receiver_id: "", request_status: ""}
  }


  # ###################################################################
  # define test results for auto-assign attrs
  # ###################################################################
  let(:request_status) {"pending"}
  

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

      it "given only required valid attributes" do
      end

      it "updating all attributes with valid values" do
        # status only
      end
    end
    
    describe "invalid and has correct error message when" do
      it "required attributes are missing" do
        # request_sender or request_receiver
      end

      it "request sender and receiver pair are duplicated" do
        # test duplicate
      end

      it "request sender and receiver pair in reverse roles are duplicated" do
        # test reverse_duplicate
      end

      it "request sender and receiver are the same" do
        # test both_duplicate
      end
        
      it "request_sender_id is outside allowable inputs" do
        # not a positive integer
      end

      it "request_receiver_id is outside allowable inputs" do
        # not a positive integer
      end

      it "request_status is outside allowable inputs" do
        # not "accepted", "rejected", "pending"
      end

      it "trys to update request sender or receiver" do
      end
    end
  end
  
end
