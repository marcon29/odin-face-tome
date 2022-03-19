class Like < ApplicationRecord
    
    belongs_to :user
    belongs_to :post

    # attrs: :user_id, :post_id

    # all attrs are required
    # can't be updated, only created and destroyed
    validates :user_id, presence: { message: "You must provide a user." }
    validates :post_id, presence: { message: "You must provide a post." }
    validate :check_user_and_post_updating
    validate :check_post_already_liked

    # let(:dupe_like_message) {"You already liked that post."}


    # only signed_in user can CRUD (or CD)
    # can CRUD only if current_user's likes
    # user can only have one like per post (no duplicate of user/post ids)



    # ################ helpers (callbacks & control flow)  ####################
    
    
    # ################ helpers (instantiation & validation)  ####################
    def check_post_already_liked
        if !self.persisted? && self.user && self.user.liked_post?(self.post)
            errors.add(:user_id, "You already liked that post.")
            errors.add(:post_id, "You already liked that post.")
        end
    end
    
    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
        # ######## working with Post model
        # ######## working with Like model
    
    
    # ################ helpers (data control)  ####################


end
