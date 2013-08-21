class Herokudb
  require "heroku/client"

  def self.get_last_backup_url
    Heroku::Command.load
    @client = Heroku::Client::Pgbackups.new ENV["PGBACKUPS_URL"]
    @client.get_latest_backup["public_url"]
  end

  def self.capture
    Heroku::Command.load
    @client = Heroku::Client::Pgbackups.new ENV["PGBACKUPS_URL"]
    @pgbackup = @client.create_transfer(Herokudb.db_url, Herokudb.db_url, nil, "BACKUP", :expire => true)
    until @pgbackup["finished_at"]
      print "."
      sleep 1
      @pgbackup = @client.get_transfer @pgbackup["id"]
    end
    @pgbackup["public_url"]
  end

  def self.db_url
    Rails.env.production? ? ENV["DATABASE_URL"] : ENV["HDATABASE_URL"]
  end
end