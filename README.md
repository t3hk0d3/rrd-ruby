# RRD::Ruby

Native ruby implementation of RRD format parsing.
Don't need all these pesky C libraries.

## Installation

Add this line to your application's Gemfile:

    gem 'rrd-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rrd-ruby

## Usage

```ruby
require 'rrd'

file = RRD::File.new("path/to/my_awesome.rrd")

# Get all Round Robin Archive infos
rra = file.rra

# Get all DataSource infos
ds = file.datasources

# Get all data from RRA in specified time interval
data = file.data(rra.first).fetch(start_time: 20.minutes.ago, end_time: 5.minutes.ago)

# Format data right in reading loop (perfomance for perfomance god!)
data = file.data(rra.first).fetch do |row, columns|
	columns # => [:time, :col1, :col2, :col3]
	row # => [123345345, 123.0, 456.0, 789.0]	

	# turn em into hash
	Hash[columns.zip(row)] # => { time: 123345345, col1: 123.0, col2: 456.0, col3: 789.0 }
end
# => [... , { time: 123345345, col1: 123.0, col2: 456.0, col3: 789.0 }, ...]

# All data read from file stream, right on spot
file.close
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request