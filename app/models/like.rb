class Like < ApplicationRecord
    belongs_to :user
    belongs_to :post

    # attrs: :user_id, :post_id

    validates :user_id, presence: { message: "You must provide a user." }
    validates :post_id, presence: { message: "You must provide a post." }
    validate :check_user_and_post_updating
    validate :check_post_already_liked


    # ################ helpers (instantiation & validation)  ####################
        def check_post_already_liked
            if !self.persisted? && self.user && self.user.liked_post?(self.post)
                errors.add(:user_id, "You already liked that post.")
                errors.add(:post_id, "You already liked that post.")
            end
        end
end
