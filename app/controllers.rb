MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do
    require 'fileutils'
    require 'tempfile'

    p params

    datafile = params[:data]
    Tempfile.new("music") do |file|
      file.write(datafile[:tempfile].read)
      logger.push "wrote to #{file.inspect}"
    end


    redirect :index
  end
end
