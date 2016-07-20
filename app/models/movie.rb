class Movie < ActiveRecord::Base

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

  def self.search(search_title, search_director, search_duration)
    search_string = ""
    conditions = []
    if !search_title.empty?
      search_string = "title = ?"
      conditions << search_title
    end

    if !search_director.empty?
      if search_string.empty?
        search_string = "director = ?"
        conditions << search_director
      else
        search_string = search_string + " AND director = ?"
        conditions << search_director
      end
    end

     if !search_string.empty?
        if search_duration == "under 90"
         search_string = search_string + " AND runtime_in_minutes < ?"
         conditions << 90
        end
        if search_duration == "Between 90 and 120"
         search_string = search_string + " AND runtime_in_minutes >= ? AND runtime_in_minutes <= ?"
         conditions << 90 << 120
        end
        if search_duration == "Over 120"
         search_string = search_string + " AND runtime_in_minutes > ?"
         conditions << 120
        end
     else
      if search_duration == "under 90"
         search_string = search_string + "runtime_in_minutes < ?"
         conditions << 90
        end
        if search_duration == "Between 90 and 120"
         search_string = search_string + "runtime_in_minutes >= ? AND runtime_in_minutes <= ?"
         conditions << 90 << 120
        end
        if search_duration == "Over 120"
         search_string = search_string + "runtime_in_minutes > ?"
         conditions << 120
        end
     end
    Movie.where(search_string, *conditions)
  end

  protected

  def release_date_is_in_the_past
    if release_date.present? && release_date > Date.today
      errors.add(:release_date, "should be in the past")
    end
  end

end
