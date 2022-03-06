class Friend < ApplicationRecord

    # belongs_to :request_sender, class: "User"
    # belongs_to :request_receiver, class: "User"

    # attrs: :request_sender_id, :request_receiver_id, :request_status
        # all attrs are required
            # status only when updating
        # status restricted to "accepted", "rejected", "pending"
            # "pending" is default value
        # only status is updateable
        # :request_sender must be a positive integer
        # :request_receiver must be a positive integer
        # :request_sender_id can't be same as :request_receiver_id
        # :request_sender_id and :request_receiver_id together can't be same combo (in either order)
        
        
    # while working with it's own data,
        # it can instantiate itself
            # with all data provided
            # with optional or default data missing
                # instantiate without status, and should still end up with "pending"
        # it can update itself
            # with all data provided (only status)
            # with optional or default data missing
                # can skip all is req
        # it can delete itself
        # it can return correct errors when
            # trying to instantiate with missing required data
                # all is req - instantiate blank and should have error message for each attr
            # trying to update with missing required
                # all is req - update blank and should have error message for each attr
            # trying to instantiate with invalid data
                # :request_sender not a integer
                    # text, float, negative
                # :request_receiver not a integer
                    # text, float, negative
                # status - anything not on list
            # trying to update with invalid data
                # :request_sender (can't be updated), so anything that's not current value 
                # :request_receiver (can't be updated), so anything that's not current value 
                # status - anything not on list (same as instantiate)
    

    # Friending Process
    #     1. current_user clicks on Add Friend button for another user
    #     2. creates Friend object
    #         - requester = current_user
    #         - accpetor = other user
    #         - status = "pending"
    #     3. request shows up in both users views (see below)
    #     4. other user selects clicks Accept button or Decline button
    #     5. finds Friend object
    #     6. Updates status to "accepted" or "rejected"
    #     7. Views update again
        
end
