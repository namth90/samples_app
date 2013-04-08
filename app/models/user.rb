# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :login, :password, 
  :password_confirmation, :password_reset_token,
  :password_reset_send_at, :admin
# binding.pry
  has_secure_password

  validates :password, presence: true, :length => { :minimum => 6 }
  validates :password_confirmation, presence: true
  # validates :password_reset_token, presence: true

  validates :name, presence: true, :length => { :maximum => 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, :format => { :with => VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }

  before_save { |user| user.email = email.downcase }
  # before_save :create_remember_token
  before_save :create_remember_token


def send_password_reset
  # binding.pry
      self.password_reset_token = SecureRandom.urlsafe_base64
      self.password_reset_send_at = Time.zone.now
      save!(:validate => false)
      UserMailer.password_reset(self).deliver
end

private

def create_remember_token
	self.remember_token = SecureRandom.urlsafe_base64
end



end
