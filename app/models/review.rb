class Review < ApplicationRecord
    belongs_to :critic
    belongs_to :movie
end
