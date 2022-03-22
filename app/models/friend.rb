class Friend < ApplicationRecord
    belongs_to :request_sender, class_name: "User"
    belongs_to :request_receiver, class_name: "User"

    # attrs: :request_sender_id, :request_receiver_id, :request_status
        
    validates :request_sender_id, presence: { message: "You must provide a request sender." }
    validates :request_receiver_id, presence: { message: "You must provide a request receiver." }
    validates :request_status, inclusion: { in: ["pending", "accepted", "rejected"], message: "Can only be pending, accepted, or rejected." }
    validates :request_status, presence: { message: "You must provide a request status." }, on: :update
    validate :check_request_roles_updating, :check_sender_receiver_already_friends, :check_sender_receiver_same_user


    # ################ helpers (instantiation & validation)  ####################
        def check_request_roles_updating
            if self.persisted?
                errors.add(:request_sender_id, "Can't change a friend request.") if self.request_sender_id_changed? 
                errors.add(:request_receiver_id, "Can't change a friend request.") if self.request_receiver_id_changed?
            end
        end
        
        def check_sender_receiver_already_friends
            new_sender_id = self.request_sender_id
            new_receiver_id = self.request_receiver_id

            if !self.persisted?            
                check_same_roles = Friend.where(request_sender_id: new_sender_id).where(request_receiver_id: new_receiver_id)
                check_reversed_roles = Friend.where(request_sender_id: new_receiver_id).where(request_receiver_id: new_sender_id)

                if check_same_roles.present? || check_reversed_roles.present?
                    errors.add(:request_receiver_id, "You two are already friends.")
                    errors.add(:request_sender_id, "You two are already friends.")
                end
            end
        end
        
        def check_sender_receiver_same_user
            if self.request_sender_id == self.request_receiver_id 
                errors.add(:request_sender_id, "You can't be friends with yourself.")
                errors.add(:request_receiver_id, "You can't be friends with yourself.")
            end
        end
end
