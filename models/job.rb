class Job < ActiveRecord::Base
  def self.schedule(song_url, image_url)
    create(:music => song_url, :image => iamge_url)
  end

  def run
    cmd = "avconv -y -loop 1 -r 2 -i \"#{image}\" -i \"#{music}\" -crf 18 -c:a libvorbis -q:a 5 -shortest -pix_fmt yuv420p \"#{dest}\""
    puts cmd
    Kernel.system cmd

    # Move final output to a tmp/ to serve
    serv = "tmp/#{Time.now.to_i}.mkv"
    FileUtils.mv(dest, serv)
  end
end
