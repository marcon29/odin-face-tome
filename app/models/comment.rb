class Comment < ApplicationRecord
    # belongs_to :user
    # belongs_to :post
    
    # down-the-road options
        # has_many :comments, :likes

    # attrs: :content, :user_id, post_id

    # all attrs are required
    # only content can be updated, not user or post
    # only signed_in user can view
    # can CRUD only if current_user's posts

    # ################ helpers (callbacks & control flow)  ####################
    
    
    # ################ helpers (instantiation & validation)  ####################
    
    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
    
        # ######## working with Post model
    
        # ######## working with Like model
    
    
    # ################ helpers (data control)  ####################
end
