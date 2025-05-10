class ChangeOmniauthColumnsInUsers < ActiveRecord::Migration[8.0]
  def up
    change_column :users, :provider, :string, null: true, default: nil
    change_column :users, :uid, :string, null: true, default: nil
    
    # 既存の空文字列のレコードをnilに更新
    User.where(provider: '').update_all(provider: nil)
    User.where(uid: '').update_all(uid: nil)
  end

  def down
    change_column :users, :provider, :string, null: false, default: ''
    change_column :users, :uid, :string, null: false, default: ''
  end
end

