class Movie < ActiveRecord::Base
  # scope :less_than_90, -> (duration){ where("runtime_in_minutes < ?", duration) }
  has_many :reviews
  mount_uploader :image, ImageUploader

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_past

  def review_average
    reviews.sum(:rating_out_of_ten) / reviews.size unless reviews.empty?
  end

  scope :title, -> (title) { where("title LIKE ?", "%#{title}%") }
  scope :director, -> (director) { where("director LIKE ?", "%#{director}%") }
  scope :less_than_90 ,-> { where("runtime_in_minutes < ?", 90)}
  scope :between_90_120 ,-> { where("runtime_in_minutes >= ? AND runtime_in_minutes <= ?", 90, 120)}
  scope :greater_than_120 ,-> { where("runtime_in_minutes > ?", 120)}

  protected

  def release_date_is_in_the_past
    if release_date.present? && release_date > Date.today
      errors.add(:release_date, "should be in the past")
    end
  end

end
