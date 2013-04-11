MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do
    "avconv -i #{params[:image][:tempfile].path} -i #{params[:music][:tempfile].path} #{Tempfile.new(['final', '.flv']).path}"
  end
end
