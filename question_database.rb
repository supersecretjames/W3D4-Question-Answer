require 'singleton'
require 'sqlite3'

class QDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("qa.db")
  end
end