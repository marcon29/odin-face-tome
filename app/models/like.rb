class Like < ApplicationRecord
    
    belongs_to :user
    belongs_to :post

    # attrs: :user_id, :post_id

    # all attrs are required
    # can't be updated, only created and destroyed
    validates :user_id, presence: { message: "You must provide a user." }
    validates :post_id, presence: { message: "You must provide a post." }
    validate :check_user_and_post_updating

    # only signed_in user can CRUD (or CD)
    # can CRUD only if current_user's likes



    # ################ helpers (callbacks & control flow)  ####################
    
    
    # ################ helpers (instantiation & validation)  ####################
    
    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
        # ######## working with Post model
        # ######## working with Like model
    
    
    # ################ helpers (data control)  ####################


end
