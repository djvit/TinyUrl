# Url model
class Url < ActiveRecord::Base
  # Validation
  web_regex = /(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix

  validates :path,
            :presence => { :message => 'is required' },
            :format   => { :with => web_regex, :message => 'is in incorrect format'}

  validates :tiny_path,
            :presence => { :message => 'is required' },
            :uniqueness => { :case_sensitive => false, :message => 'has to be unique' }

  # tiny_url initialization
  before_validation :shorten_url, on: :create

  # Relations
  belongs_to :user

  # Generate shortened Url
  def shorten_url
    self.tiny_path ||= SecureRandom.urlsafe_base64(5)[0, 5].downcase
  end
end
