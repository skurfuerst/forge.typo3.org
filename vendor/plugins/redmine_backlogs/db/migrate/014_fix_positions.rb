class FixPositions < ActiveRecord::Migration
  def self.up
    errors = []
    Issue.find(:all, :conditions => "subject is NULL or (start_date is null and not due_date is null) or start_date > due_date or updated_on < created_on").each do |issue|
      errors << issue.id
    end

    if errors.size > 0
      puts "You have issues in your database that have one or more of the following problems:"
      puts "* subject is empty or NULL"
      puts "* due date is set, but start date is not"
      puts "* start date is later than due date"
      puts "* updated-date is before created-date"
      raise "Please fix the issues with the follwing IDs and retry the migration"
      errors.each {|id|
        puts "- #{id}"
      }
    end

    ActiveRecord::Base.transaction do
      Story.find(:all, :conditions => "parent_id is NULL", :order => "project_id ASC, fixed_version_id ASC, position ASC").each_with_index do |s,i|
        s.position=i+1
        s.save!
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
