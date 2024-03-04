class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  paginates_per 10
end
