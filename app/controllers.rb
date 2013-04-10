MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do

    redirect :index
  end
end
