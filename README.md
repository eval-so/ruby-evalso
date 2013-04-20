# Evalso

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'evalso'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evalso

## Usage

```ruby
require 'evalso'

p Evalso.run(:ruby, "puts 'lawl')

# Example output:
#   #<Evalso::Response code="puts 'lawl'" stdout="lawl\n" stderr="" wall_time=1666>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
