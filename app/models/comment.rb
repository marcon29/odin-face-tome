class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :post

    # down-the-road options
        # has_many :comments, :likes

    # attrs: :content, :user_id, post_id

    # all attrs are required
    # only content can be updated, not user or post
    validates :content, presence: { message: "You must provide some content to your comment." }
    validates :user_id, presence: { message: "You must provide a user." }
    validates :post_id, presence: { message: "You must provide a post." }
    validate :check_user_and_post_updating
    before_validation :format_content

    # only signed_in user can view
    # can CRUD only if current_user's posts

    # ################ helpers (callbacks & control flow)  ####################
    
    
    # ################ helpers (instantiation & validation)  ####################
    def check_user_and_post_updating
        if self.persisted?
            errors.add(:user_id, "Can't change the user of a comment.") if self.user_id_changed? 
            errors.add(:post_id, "Can't change the post of a comment.") if self.post_id_changed? 
        end
    end
    
    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
    
        # ######## working with Post model
        def self.all_by_post(post)
            Comment.where(post: post)
        end
    
        # ######## working with Like model
    
    
    # ################ helpers (data control)  ####################
end
