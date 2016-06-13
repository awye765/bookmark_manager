require 'data_mapper'
require 'dm-postgres-adapter'

class Link
  # This class corresponds to a table in the database
  include DataMapper::Resource
  # Adds DataMapper functionality to this class so it can communicate with db
  property :id, Serial
  property :title, String
  property :url, String
  # These property declarations set the column headers in the 'links' table

end

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_test")
# This connects to the db
DataMapper.finalize
# This checks everything written in the models was OK
DataMapper.auto_upgrade!
# This builds any new columns or tables we added above

# WHAT DOES THIS CLASS DO?
#
# This class prescribes a relationship between (1) a table in the db (with the
# name 'links') and (2) the Link class.  An instance of Link class is MAPPED to
# one row of the 'links' table.
#
