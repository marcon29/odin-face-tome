class User < ApplicationRecord
    # assoc
        # has_many :friends (as: ????)
        # has_many :initiated_friendships (via Friend, as :request_sender )
        # has_many :accepted_friendships (via Friend, as :request_receiver)
        # has_many :posts, :comments, :likes


    # attrs: :first_name, :last_name, :username, :email, :password
        # all attrs are required
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

    
    # while working with it's own data,
        # it can instantiate itself
            # with all data provided
            # with optional or default data missing
                # can skip all is req, and pre-formatted attrs don't change validations
        # it can update itself
            # with all data provided
            # with optional or default data missing
                # can skip all is req, and pre-formatted attrs don't change validations
        # it can delete itself
        # it can return correct errors when
            # trying to instantiate with missing required data
                # all is req - instantiate blank and should have error message for each attr
            # trying to update with missing required
                # all is req - update blank and should have error message for each attr
            # trying to instantiate with invalid data
                # username - is duplicated
                # username - contains anything other than letters or numbers
                # email - bad format
                    # has spaces, has double dot, missing local, missing @, missing dot, missing extension, short extension, long extension, bad extension (number)
                # email - is duplicated
            # trying to update with invalid data
                # same as instantiate
        # it can create a full name
        # it can format names to be init cap
        # it can format the username to remove spaces and be lowercase
        # it can format the email to remove spaces and be lowercase

    # while interacting with other users (through friends),
        # it can find all pending friend requests where self was request_sender
            # self.initiated_friendships
        # it can find all pending friend requests where self was request_receiver
            # self.accepted_friendships
        # it can find all friends
            # self.friends
        # it can initiate a friend request
            # self.friends.build
        # it can update a friend request to accept or reject it
            # self.friends.update
        # it can unfriend someone
            # self.friends.destroy

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

end
