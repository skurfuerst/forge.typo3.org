class CreateJabberSubscriptions < ActiveRecord::Migration
  
  def self.up
    create_table "jabber_subscriptions" do |t|
      t.column "user_id", :integer, :default => 0, :null => false
      t.column "project_id", :integer, :default => 0, :null => false
    end
  end
  
  def self.down
    drop_table :jabber_subscriptions
  end
end