require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :requests

  attr_accessible :email, :shadow
#  attr_reader :email
  
  validates :shadow, :presence => true, :uniqueness => true


  def User.endark mail
    Digest::SHA256.hexdigest(mail)
  end

  def User.summon mail
    dark_mail = User.endark mail
    
    User.where(:shadow => dark_mail).first_or_create(:email => mail)
  end
  
#  def set_shadow dark_mail
#    shadow = dark_mail if shadow.nil?
#  end

#  def set_email mail
#    email = mail if email.nil?  
#  end
end
