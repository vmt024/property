require 'digest'
class User < ActiveRecord::Base
  before_create :validate_password
  before_save :encrypt_password

  attr_accessor :confirm_password

  validates_uniqueness_of :email
  validates_presence_of :name,:email

  has_many :properties, :class_name => 'PropertyAccount'
  
  
  def correct_password?(submitted_password)
    self.password == encrypt(submitted_password)
  end
  
  private


  def encrypt_password
    self.salt = generate_salt if new_record?
    self.password = encrypt(password)
    self.confirm_password = encrypt(confirm_password)
  end

  # convert plain text string to hash
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  # encrypt user password with salt
  def encrypt(password)
    secure_hash("#{salt}--#{password}")
  end

  # generate salt for user password encryption
  def generate_salt
    secure_hash("#{Time.now}--#{password}")
  end

  # check password and password confirmation are same
  def validate_password
    if self.password != self.confirm_password
      self.errors.add('confirm_password','password not match to confirm password')
     return false
    end
  end
end
