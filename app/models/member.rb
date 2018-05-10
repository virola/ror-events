class Member < ApplicationRecord
  has_secure_password

  # validations
  validates :username, presence: { message: '不能为空' }
  validates :username, uniqueness: { message: '数据库中已存在' }
  validates :password, presence: { message: '不能为空' }, on: :create
  validates :password, length: { in: 6..20, message: '长度为6-20位' }, on: :create
  
  validates :open_id, uniqueness: { message: '数据库中已存在' }
  validates :union_id, uniqueness: { message: '数据库中已存在' }

  # key map
  has_many :events, :dependent => :destroy

  # 修改密码时
  attr_accessor :new_password, :new_password_confirmation
  # validates :new_password, presence: true, confirmation: true, length: { in: 6..20 }, on: :create
  validates :new_password, presence: true, confirmation: true, length: { in: 6..20 }, on: :update, if: :password_changed?
  # validates :new_password_confirmation, presence: true, on: :create
  validates :new_password_confirmation, presence: true, on: :update, if: :password_changed?

  def password_changed?
    !new_password.blank?
  end

  def role
    role = id < 5 ? 'admin': 'user'
  end

  before_create :generate_authentication_token

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.base64(64)
      break if !Member.find_by(authentication_token: authentication_token)
    end
  end

  def reset_auth_token!
    generate_authentication_token
    save
  end
end
