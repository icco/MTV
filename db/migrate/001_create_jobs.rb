class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :music
      t.string :image
      t.string :local_url
      t.string :published_url
      t.boolean :lock
      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
