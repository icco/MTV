MTV::App.controllers  do
  get :index do
    render :youtube
  end

  get :merge do
    render :index
  end

  post :index do
    require 'fileutils'

    dest = Tempfile.new(['final', '.flv']).path
    image = Tempfile.new(['', params[:image][:filename]]).path
    music = Tempfile.new(['', params[:music][:filename]]).path

    FileUtils.mv(params[:image][:tempfile].path, image)
    FileUtils.mv(params[:music][:tempfile].path, music)

    cmd = "avconv -y -i \"#{image}\" -i \"#{music}\" \"#{dest}\""
    puts cmd
    Kernel.system cmd

    serv = "tmp/#{Time.now.to_i}.flv"
    FileUtils.mv(dest, serv)

    haml '%a{:href => file}="/#{file}"', :locals => { :file => serv }
  end

  get '/tmp/:file' do
    path = Padrino.root("tmp", params[:file])
    send_file path, :disposition => :attachment
  end
end
