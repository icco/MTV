class Job < ActiveRecord::Base
  def self.schedule(song_url, image_url)
    create(:music => song_url, :image => iamge_url)
  end

  def run

  end
end
