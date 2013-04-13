MTV::App.controllers  do
  get :index do
    render :youtube
  end

  get :merge do
    render :index
  end

  post :index do
    require 'fileutils'

    # Move music file
    music = Tempfile.new(['', params[:music][:filename]]).path
    FileUtils.mv(params[:music][:tempfile].path, music)

    # Resize and move image
    image = Tempfile.new(['', params[:image][:filename]]).path
    img = Magick::Image::read(params[:image][:tempfile].path).first
    # We could resize, but better to just let it be for me.
    #img.resize_to_fill!(1280, 720)
    img.write image

    # Combine image and music and write to a temp file.
    # More details: http://ffmpeg.org/trac/ffmpeg/wiki/EncodeforYouTube
    dest = Tempfile.new(['final', '.mkv']).path
    cmd = "avconv -y -loop 1 -r 2 -i \"#{image}\" -i \"#{music}\" -crf 18 -c:a libvorbis -q:a 5 -shortest -pix_fmt yuv420p \"#{dest}\""
    puts cmd
    Kernel.system cmd

    # Move final output to a tmp/ to serve
    serv = "tmp/#{Time.now.to_i}.mkv"
    FileUtils.mv(dest, serv)

    haml '%a{:href => file}="/#{file}"', :locals => { :file => serv }
  end

  get '/tmp/:file' do
    path = Padrino.root("tmp", params[:file])
    send_file path, :disposition => :attachment
  end
end
