MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do
    require 'fileutils'
    p params[:image]

    dest = Tempfile.new(['final', '.flv']).path
    image = Tempfile.new(['', params[:image][:filename]]).path
    music = Tempfile.new(['', params[:music][:filename]]).path

    FileUtils.mv(params[:image][:tempfile].path, image)
    FileUtils.mv(params[:music][:tempfile].path, music)

    Kernel.system "avconv -i #{image} -i #{music} #{dest}"

    dest
  end
end
