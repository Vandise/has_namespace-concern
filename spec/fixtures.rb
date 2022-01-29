require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :administration_users, force: true do |t|
    t.integer :user_team_id
    t.string :name
    t.string :email
    t.timestamps null: false
  end

  create_table :profile_pictures, force: true do |t|
    t.belongs_to :administration_user
    t.string :url
    t.timestamps null: false
  end

  create_table :content_posts, force: true do |t|
    t.belongs_to :administration_user
    t.string :title
    t.text :body
    t.timestamps null: false
  end

  create_table :content_tags, force: true do |t|
    t.string :name
    t.timestamps null: false
  end

  create_table :legacy_teams, force: true do |t|
    t.string :name
    t.timestamps null: false
  end

  create_join_table :content_posts, :content_tags
end

module Account
  class Team < ActiveRecord::Base
    include HasNamespace::Concern
    self.namespaced_table = 'legacy_teams'

    has_many! :users, namespace: 'Administration', foreign_key: 'user_team_id'
  end
end

module Administration
  class User < ActiveRecord::Base
    include HasNamespace::Concern

    has_many! :posts, namespace: 'Content'
    has_one!  :picture, namespace: 'Profile'
    belongs_to! :team, foreign_key: 'user_team_id', class_name: 'Account::Team'
  end
end

module Profile
  class Picture < ActiveRecord::Base
    include HasNamespace::Concern
    belongs_to! :user, namespace: 'Administration'
  end
end

module Content
  class Post < ActiveRecord::Base
    include HasNamespace::Concern

    belongs_to! :user, namespace: 'Administration'
    has_and_belongs_to_many! :tags
  end

  class Tag < ActiveRecord::Base
    include HasNamespace::Concern

    has_and_belongs_to_many! :posts
  end
end