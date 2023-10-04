class KeyPerson < ApplicationRecord

  belongs_to :lic

  def kp_bio_cleaned
    kp_bio.gsub("\n", "<br>").gsub("&", "and")
  end
  
end
