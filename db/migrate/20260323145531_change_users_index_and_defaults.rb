class ChangeUsersIndexAndDefaults < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, :email
    change_column_null :users, :email, true
    change_column_null :users, :uid, false
    change_column_null :users, :provider, false
    change_column_default :users, :email, from: "", to: ""
    change_column_default :users, :provider, from: nil, to: "saml"
  end
end
