MTV::App.controllers  do
  get :index do
    render :index
  end

  post :index do
    require 'fileutils'

    dest = Tempfile.new(['final', '.flv']).path
    image = Tempfile.new(['', params[:image][:filename]]).path
    music = Tempfile.new(['', params[:music][:filename]]).path

    FileUtils.mv(params[:image][:tempfile].path, image)
    FileUtils.mv(params[:music][:tempfile].path, music)

    cmd = "avconv -i \"#{image}\" -i \"#{music}\" \"#{dest}\""
    puts cmd
    Kernel.system cmd

    serv = "tmp/#{Time.now.to_i}.flv"
    FileUtils.mv(dest, serv)

    haml '%a{:href => file}=file', :locals => { :file => serv }
  end

  get '/tmp/:file' do
    send_file File.expand_path("tmp/#{params[:file]}", File.dirname(__FILE__))
  end
end
