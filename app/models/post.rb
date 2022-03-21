class Post < ApplicationRecord

    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    # attrs: :content, :user_id

    # all attrs are required
    # only content can be updated, not user
    validates :content, presence: { message: "You must provide some content to post." }
    validates :user_id, presence: { message: "You must provide a user." }
    validate :check_user_updating
    before_validation :format_content
    
    # only signed_in user can view
    # can CRUD only if current_user's posts

    


    # ################ helpers (callbacks & control flow)  ####################
    
    
    # ################ helpers (instantiation & validation)  ####################
    def check_user_updating
        if self.persisted?
            errors.add(:user_id, "Can't change the user of a post.") if self.user_id_changed? 
        end
    end
    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
            def self.all_by_user(user)
                self.where(user: user)
            end
            
            def self.all_by_user_collection(users)
                Post.where(user: [users])
            end
    
        # ######## working with Comment model
            # p/u from Post test file
    
    
        # ######## working with Like model
            # p/u from Post test file
    
    
    # ################ helpers (data control)  ####################
    
    
    
    
end
