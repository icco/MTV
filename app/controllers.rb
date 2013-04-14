MTV::App.controllers  do
  get :index do
    render :youtube
  end

  get :merge do
    render :index
  end

  post :index do
    # Move music file
    music = Tempfile.new(['', params[:music][:filename]]).path
    FileUtils.mv(params[:music][:tempfile].path, music)

    # Resize and move image
    image = Tempfile.new(['', params[:image][:filename]]).path
    img = Magick::Image::read(params[:image][:tempfile].path).first
    img.scale!(1280, 720)
    img.write image

    Job.schedule(music, image)

    redirect '/tmp/'
  end

  get '/tmp/' do
    path = Padrino.root("tmp", "video")

    if not Dir.exist? path
      FileUtils.mkdir_p path
    end

    ret = ""
    Dir.entries(path).each do |file|
      ret += "<li><a href=\"/tmp/#{file}\">#{file}</a></li>"
    end

    ret
  end

  get '/tmp/:file' do
    path = Padrino.root("tmp", "video", params[:file])
    send_file path, :disposition => :attachment
  end
end
