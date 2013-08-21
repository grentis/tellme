class BackupController < ApplicationController
  def create
  end

  def create_task
    @db = Herokudb.get_last_backup_url #Herokudb.capture
    sleep 10
    render json: { url: @db }
  end

  def get
    redirect_to Herokudb.get_last_backup_url
  end
end
