class Request < ActiveRecord::Base
  belongs_to :user

  attr_accessible :attachment, :message, :url, :status
  
  mount_uploader :attachment, AttachmentUploader

  validates :url, :presence => true

  def active?
    (-2..0).member? self.status
  end

  def activate!
    self.status = 0
  end

  def deactivate!
    self.status = -3
  end

  def latent?
    self.status == -3
  end

  def degrade!
    self.status -= 1 if active?
  end

end
