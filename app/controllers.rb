MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do
    dest = Tempfile.new(['final', '.flv']).path
    Kernel.system "avconv -i #{params[:image][:tempfile].path} -i #{params[:music][:tempfile].path} #{dest}"

    dest
  end
end
