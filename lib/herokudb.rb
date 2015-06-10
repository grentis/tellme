class Herokudb
  require "heroku/client"
  require "heroku/jsplugin"

  def self.get_last_backup_url
    Heroku::Command.load
    #@client = Heroku::Client::Pgbackups.new ENV["PGBACKUPS_URL"]
    #@client.get_latest_backup["public_url"]

    @client = Heroku::Client::HerokuPostgresqlApp.new Herokudb.heroku_appname
    @client.transfers_public_url(@client.transfers.sort_by{ |k| k[:updated_at]}.reverse[0][:uuid])[:url]
  end

  def self.capture
    Heroku::Command.load
    @resolver = Heroku::Helpers::HerokuPostgresql::Resolver.new Herokudb.heroku_appname, Heroku::Auth.api
    @client = Heroku::Client::HerokuPostgresql.new @resolver.all_databases["DATABASE_URL"]
    #@client.backups
    @backup = @client.backups_capture
    @status = @client.backups_get (@backup[:uuid])
    until @status[:finished_at]
      sleep 1
      @status = @client.backups_get (@backup[:uuid])
    end
    sleep 5
    Herokudb.get_last_backup_url

    #@client = Heroku::Client::Pgbackups.new ENV["PGBACKUPS_URL"]
    #@pgbackup = @client.create_transfer(Herokudb.db_url, Herokudb.db_url, nil, "BACKUP", :expire => true)
    #until @pgbackup["finished_at"]
    #  sleep 1
    #  @pgbackup = @client.get_transfer @pgbackup["id"]
    #end
    #@pgbackup["public_url"]
  end

  def self.db_url
    Rails.env.production? ? ENV["DATABASE_URL"] : ENV["HDATABASE_URL"]
  end

  def self.heroku_appname
    'gtellme'
  end
end