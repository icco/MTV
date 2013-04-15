class SC
  attr_accessor :client

  def initialize
    @client = Soundcloud.new(
      :client_id => ENV['SOUNDCLOUD_ID'],
      :client_secret  => ENV['SOUNDCLOUD_SECRET'],
    )
  end

  # Takes a soundcloud url and saves it to disk.
  #
  # @param url [String] The soundcloud url to download from.
  # @param options [Hash] settings to override the default settings.
  # @return [String] the location of the saved file.
  def self.get_track url, options = {}
    require 'open-uri'
    require 'securerandom'

    default_options = {
      :dir => '/tmp',
      :filename => "#{SecureRandom.hex(13)}.mp3"
    }

    sc = SC.new
    options = default_options.merge(options)
    track = sc.client.get('/resolve', :url => url)
    dest = "#{options[:dir]}/#{options[:filename]}"

    if track.downloadable
      File.open(dest, "wb") do |saved_file|
        open(track.download_url) do |read_file|
          saved_file.write(read_file.read)
        end
      end

      return dest
    else
      # There is no download file, abort.
      return nil
    end
  end
end
