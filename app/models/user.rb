class User < ApplicationRecord
    has_many :sent_friendship_requests, foreign_key: "request_sender_id", class_name: "Friend"
    has_many :received_friendship_requests, foreign_key: "request_receiver_id", class_name: "Friend"
    # has_many :posts, :comments, :likes

    # attrs: :first_name, :last_name, :username, :email, :password
        
    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :username, 
        presence: { message: "You must provide a username." }, 
        uniqueness: { case_sensitive: false, message: "That username is already used." }, 
        format: { with: /\A\w+\z/, message: "Username can only use letters and numbers without spaces." }
    validates :email, 
        presence: { message: "You must provide your email." }, 
        uniqueness: { case_sensitive: false, message: "That email is already used." }, 
        format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Email doesn't look valid. Please use another." }

    # probably be deleted after setting up Devise gem
    validates :password, 
        presence: { message: "You must provide a password." }, 
        length: { minimum: 6, message: "Password must be 6 characters or more." }
    before_validation :format_names, :format_username, :format_email


    # ################ helpers (callbacks & control flow)  ####################
   
        

    # ################ helpers (instantiation & validation)  ####################



    # ################ helpers (nested or associated models)  ####################
    
    # ######## working with Friend model
    
    # it can initiate a friend request
        
    # it can update a received request to accept it

    # it can update a received request to reject it
    
    # it can cancel a sent friend request
    # it can unfriend someone
    
    # it can find all pending friend requests where self was request_sender
    
    # it can find all pending friend requests where self was request_receiver
    
    # it can find all friends
        
        

    # ######## working with Post, Comment, Like models
    # while interacting with posts, 
        # it can create a new post
            # self.posts.build
        # it can find all of it's own posts
            # self.posts.where(user: current_user)
        # it can find all posts of friends
        # it can comment on a post
            # self.comments.build
        # it can like a post
            # self.likes.build


    # ################ helpers (data control)  ####################
    def full_name
        "#{self.first_name.capitalize} #{self.last_name.capitalize}"
    end
    
    def format_names
        self.first_name = self.first_name.capitalize if self.first_name.present?
        self.last_name = self.last_name.capitalize if self.last_name.present?
    end
    
    def format_username
        self.username = self.username.downcase.gsub(" ","")
    end
    
    def format_email
        self.email = self.email.downcase.gsub(" ","")
    end    

    

end
