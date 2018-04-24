class Event < ApplicationRecord
  # 验证名称
  validates_presence_of :name
  validates_presence_of :date

  # 关联用户
  belongs_to :member
end
