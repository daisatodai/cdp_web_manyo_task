class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  before_validation { email.downcase! }
  has_secure_password
  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy
  before_update :admin_cannot_update
  before_destroy :admin_cannot_delete

  private
    def admin_cannot_update
      admin_count = User.where(admin: true).count
      if admin_count == 1 && self.changes[:admin] == [true, false]
        self.errors.add(:base, "管理者が0人になるため権限を変更できません" )
        throw :abort
      end
    end

    def admin_cannot_delete
      admin_count = User.where(admin: true).count
      if admin_count == 1 && self.admin
        self.errors.add(:base, "管理者が0人になるため削除できません" )
        throw :abort
      end
    end


end
