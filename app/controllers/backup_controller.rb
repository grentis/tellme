class BackupController < ApplicationController
  def create
  end

  def create_task
    @db = Herokudb.capture
    #@db = Herokudb.get_last_backup_url
    #sleep 50
    render json: { url: @db }
  end

  def get
    redirect_to Herokudb.get_last_backup_url
  end

  def export
    @clients = Client.find(:all, order: :name)
    content = (render_to_string 'backup/export', layout: false).gsub(/\n/, "\r\n")
    send_data content,:type => 'text/plain; charset=utf-8',:disposition => "attachment; filename=dati_"+ l(Time.now, format: '%d.%m.%Y') +".txt"
  end
end
