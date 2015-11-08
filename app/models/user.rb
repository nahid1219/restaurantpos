class User < ActiveRecord::Base
  #attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  attr_accessor :password_confirmation
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :user_name
  validates_uniqueness_of :user_name
  
  def self.authenticate(username, password)
    user = find_by_user_name(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def is_admin?
    if admin
      return true
    else
      return false
    end
  end    
    
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
