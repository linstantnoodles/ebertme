class Critic < ApplicationRecord
    has_many :reviews

    scope :reviews_by_critic_name, ->(name) {
        return all if name.blank?
        includes(:reviews, :movies).where(name: name)
  }

end
