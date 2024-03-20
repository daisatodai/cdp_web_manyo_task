class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  belongs_to :user, foreign_key: 'user_id'
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels, source: :label
  enum priority: {
    low: 0,
    middle: 1,
    high: 2
  }

  enum status: {
    waiting: 0,
    working: 1,
    completed: 2,
  }
  paginates_per 10

  scope :sort_by_created_at, -> {order(created_at: :desc)}
  scope :sort_deadline_on, -> {order(deadline_on: :asc)}
  scope :sort_priority, -> {order(priority: :desc)}

  # scope :search, -> (search_params) do
  #   return if search_params.blank?
  #   status_is(search_params[:status]).title_like(search_params[:title])
  # end
  scope :search_title_status, -> (title, status){where('title LIKE ?',"%#{title}%").where(status: status)}
  scope :status_is, -> (status)  { where(status: status) if status.present? }
  scope :title_like, -> (title) { where('title LIKE ?', '%' + title + '%') if title.present? }
  scope :label_search, -> (label_id) { joins(:labels).where(labels: {id: label_id}) if label_id.present? }
  # status_isが存在する場合、status_isで検索する
end
