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
end
