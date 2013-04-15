MTV::App.controllers  do
  layout :main

  get :index do
    render :youtube, :layout => false
  end

  get :merge do
    render :index
  end

  post :index do
    # music file
    music = params[:music]

    # Resize and move image
    image = "/tmp/#{Time.new.to_f}_#{params[:image][:filename]}"
    img = Magick::Image::read(params[:image][:tempfile].path).first
    img.scale!(1280, 720)
    img.write image

    Job.schedule(music, image)

    redirect '/tmp/'
  end

  get '/tmp/' do
    headers "Refresh" => "20"

    path = Padrino.root("tmp", "video")

    if not Dir.exist? path
      FileUtils.mkdir_p path
    end

    F = Struct.new(:name, :mtime, :url)
    @files = Dir.entries(path).sort.delete_if {|x| x.start_with? '.' }.map do |f|
      file = F.new
      file.name = f
      file.url = "/tmp/#{f}"
      file.mtime = File.mtime(File.join(path, f))

      file
    end

    render :tmp
  end

  get '/tmp/:file' do
    path = Padrino.root("tmp", "video", params[:file])
    send_file path, :disposition => :attachment
  end
end
