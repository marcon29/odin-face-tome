class Post < ApplicationRecord

    # belongs_to :user
    # has_many :comments, :likes

    # attrs: :content, :user_id

    # all attrs are required
    # only content can be updated, not user
    validates :content, presence: { message: "You must provide some content to post." }
    validates :user_id, presence: { message: "You must provide a user." }
    validate :check_user_updating
    before_validation :format_content
    
    # only signed_in user can view
    # only can CRUD only if current_user's posts

    


    # ################ helpers (callbacks & control flow)  ####################
    
    
    # ################ helpers (instantiation & validation)  ####################
    def check_user_updating
        if self.persisted?
            errors.add(:user_id, "Can't change the user of a post.") if self.user_id_changed? 
        end
    end
    
    # ################ helpers (nested or associated models)  ####################
        # ######## working with User model
            # these may be User functions
            # can collect all posts from a specific user
                # user.posts??? this is a User function, maybe - posts_by_user(user)
                    # would I ever call post.posts_by_user
                    # class method?? Post.by_user(user)
              
            # can collect all posts from a collection of users
                    # User function??, maybe - by_user_collection(collection)
                        # would I ever call post.by_user_collection
                        # class method?? Post.by_user_collection(collection)
                        # can combine current_user's posts with current_users's friends' posts (this will generate feed)
        
    
        # ######## working with Comment model
            # p/u from Post test file
    
    
        # ######## working with Like model
            # p/u from Post test file
    
    
    # ################ helpers (data control)  ####################
    
    # can remove beginning and trailing white space
    def format_content
        self.content = self.content.strip
    end
    
end
