class AddNicknameToMembers < ActiveRecord::Migration[5.2]
  def change
    # 微信昵称
    add_column :members, :nickname, :string
  end
end
