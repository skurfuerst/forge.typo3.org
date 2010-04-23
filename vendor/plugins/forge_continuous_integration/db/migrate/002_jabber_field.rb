class JabberField < ActiveRecord::Migration

  def self.up
    add_column :users, :jabber_id, :string
  end

  def self.down
    remove_column :users, :jabber_id
  end
end