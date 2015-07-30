class Photo < ActiveRecord::Base

  has_attached_file :image, :styles => {:large => "640x480>",
                                          :medium => "480x320>",
                                          :thumb => "200x200#"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # after_commit :email_people, on: :create
  #
  # def email_people
  #   logger.debug("Started job for #{self.id}")
  #   PhotoEmailWorker.perform_async(self.id)
  # end
end
