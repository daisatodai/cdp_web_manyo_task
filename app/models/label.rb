class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy, foreign_key: 'label_id'
  has_many :tasks, through: :task_labels, source: :task
  belongs_to :user
  validates :name, presence: true
end
