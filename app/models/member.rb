class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  has_secure_password

  # validations
  validates :username, presence: { message: "不能为空" }
  validates :username, uniqueness: { message: "用户名已存在" }
  validates :password, presence: { message: "不能为空" }
  validates :password, length: { minimum: 6, message: "长度最短为6位" }

  # key map
  has_many :events, :dependent => :destroy
end
