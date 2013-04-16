class SC
  def initialize
    # Test authentication
    self.client.get('/me').username
  end

  def client
    args = {
      :client_id => ENV['SOUNDCLOUD_ID'],
      :client_secret  => ENV['SOUNDCLOUD_KEY'],

      # TODO(icco): Replace with OAuth
      :username => ENV['SOUNDCLOUD_EMAIL'],
      :password => ENV['SOUNDCLOUD_PASSWORD'],
    }
    return Soundcloud.new(args)
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
      :filename => "#{SecureRandom.hex(13)}"
    }

    logger.info "Getting #{url.inspect}"
    sc = SC.new
    options = default_options.merge(options)
    track = sc.client.get('/resolve', :url => url, :client_id => ENV['SOUNDCLOUD_ID'])
    dest = "#{options[:dir]}/#{options[:filename]}.#{track.original_format}"

    if track.downloadable
      File.open(dest, "wb") do |saved_file|
        saved_file << sc.client.get(track.download_url)
      end

      logger.debug "File downloaded: #{dest.inspect}: #{File.size(dest)}"

      return dest
    else
      # There is no download file, abort.
      return nil
    end
  end
end
