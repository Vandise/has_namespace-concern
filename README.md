# HasNamespace::Concern

Defines methods that prefix ActiveRecord associations based on the module the model is defined in.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_namespace-concern'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install has_namespace-concern

## Usage

The HasNamespace concern preserves the original ActiveRecord association interface. All association-builder methods are appended with `!`. For example, if you want to have a **User** model in the namespace **Account** that has many **Articles** in the namespace **Content**, your database schema would be defined as follows:

```rb
create_table :account_users do |t|
  t.string :name
  ...
end

create_table :content_articles do |t|
  t.belongs_to :account_user
  ...
end
```

Your model definitions would then establish the association by using the bang (`!`) association methods and state the namespace the model is found in.

```rb
module Account
  class User < ApplicationRecord
    include HasNamespace::Concern
    has_many! :articles, namespace: 'Content'
  end
end

module Content
  class Article < ApplicationRecord
    include HasNamespace::Concern
    belongs_to! :user, namespace: 'Account'
  end
end
```

### Non-standard tables

If your tables do not follow the naming convention `<module_name>_<module_name>_<model_name>`, you can override the table specification through the `namespaced_table` class attribute.

```rb
module Account
  class Team < ActiveRecord::Base
    include HasNamespace::Concern
    self.namespaced_table = 'legacy_teams'
  end
end
```

### Non-standard foreign keys, class names, etc

The original ActiveRecord interface for association methods is preserved. The only exception is the `namespaced_table` attribute must be set instead of `table_name`.

```rb
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

    belongs_to! :team, foreign_key: 'user_team_id', class_name: 'Account::Team'
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vandise/has_namespace-concern. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/vandise/has_namespace-concern/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HasNamespace::Concern project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vandise/has_namespace-concern/blob/master/CODE_OF_CONDUCT.md).
