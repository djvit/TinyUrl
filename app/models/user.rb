# User model
class User < ActiveRecord::Base
  # bcrypt authentication support
  has_secure_password

  # Validation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,
            :presence => { :message => 'is required' },
            :format   => { :with => email_regex, :message => 'is in incorrect format'},
            :uniqueness => { :case_sensitive => false, :message => 'you provided is already taken' }

  validates :password,
            :presence => { :message => 'is required' },
            :length => { in: 6..40, :message => 'should be at least 6 characters and not greater than 20 characters in length' },
            :on => :create

  # Access token initialization
  before_validation :update_token, on: :create

  # Relations
  has_many :urls

  # Perform sign-in
  def signin
    self.update_token
    self.save!
  end

  # Perform sign-out
  def signout
    self.access_token = nil
    self.save!
  end

  # Is signed in ?
  def signedin?
    !self.access_token.nil?
  end

  # Generate default token
  def update_token
    self.access_token = SecureRandom.urlsafe_base64
  end
end