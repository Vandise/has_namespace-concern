require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  self.verbose = false
  create_table :people, force: true do |t|
    t.string :name
    t.string :catch_phrase
    t.timestamps null: false
  end
  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.timestamps null: false
  end
end

class Person < ActiveRecord::Base; end;
class User < ActiveRecord::Base; end;