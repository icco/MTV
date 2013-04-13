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

    Job.create(music, image)
  end

  get '/tmp/:file' do
    path = Padrino.root("tmp", params[:file])
    send_file path, :disposition => :attachment
  end
end
