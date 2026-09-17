class ChangeUsersToRegistrationColumns < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :nickname, :string
    add_column :users, :encrypted_password, :string
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name_kana, :string
    add_column :users, :first_name_kana, :string
    add_column :users, :birthday, :date

    execute <<~SQL
      UPDATE users
      SET
        nickname = name,
        encrypted_password = password_digest,
        last_name = '山田',
        first_name = '太郎',
        last_name_kana = 'ヤマダ',
        first_name_kana = 'タロウ',
        birthday = '1990-01-01'
    SQL

    change_column_null :users, :nickname, false
    change_column_null :users, :encrypted_password, false
    change_column_null :users, :last_name, false
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name_kana, false
    change_column_null :users, :first_name_kana, false
    change_column_null :users, :birthday, false

    remove_column :users, :name
    remove_column :users, :password_digest
  end

  def down
    add_column :users, :name, :string
    add_column :users, :password_digest, :string

    execute <<~SQL
      UPDATE users
      SET
        name = nickname,
        password_digest = encrypted_password
    SQL

    change_column_null :users, :name, false
    change_column_null :users, :password_digest, false

    remove_column :users, :nickname
    remove_column :users, :encrypted_password
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :last_name_kana
    remove_column :users, :first_name_kana
    remove_column :users, :birthday
  end
end
