require 'debug'
require 'awesome_print'

class App < Sinatra::Base
  def db
    return @db if @db

    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    @db
  end

  get '/' do
    @cookies = db.execute("SELECT * FROM cookies")
    erb(:"index")
  end

  get '/cookies/:id' do |id|
    @cookie = db.execute("SELECT * FROM cookies WHERE id = ?", [id]).first
    erb(:"cookie")
  end
end