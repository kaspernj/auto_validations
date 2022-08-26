# ActiveRecordAutoValidations
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "active_record_auto_validations"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install active_record_auto_validations
```

Add this initializer:
```ruby
Rails.autoloaders.main.on_load do |_klass_name, klass, _defined_by_file|
  ActiveRecordAutoValidations::OnLoad.execute!(klass: klass)
end
```

To run auto-validations on all models you can add something like this to ApplicationRecord:
```ruby
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.inherited(child)
    super
    child.include ActiveRecordAutoValidations::ModelConcern
  end
end
```

To run auto-validations on a single model you can do this:
```ruby
class Project < ApplicationRecord
  include ActiveRecordAutoValidations::ModelConcern
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
