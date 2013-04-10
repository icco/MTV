MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do
    "avconv -i #{params[:image][:tempfile]} -i #{params[:music][:tempfile]} final.flv"
  end
end
