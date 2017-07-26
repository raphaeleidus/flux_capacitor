[![Gem Version](https://badge.fury.io/rb/flux_capacitor.svg)](https://badge.fury.io/rb/flux_capacitor)
[![security](https://hakiri.io/github/raphaeleidus/flux_capacitor/master.svg)](https://hakiri.io/github/raphaeleidus/flux_capacitor/master)

# FluxCapacitor

Sometimes you want to change a feature or deploy a new feature but doing so all at once might take down some service. Enter Flux Capacitor. It allows you to gradually include more historical content in the new feature while allowing all future content to start out with the new feature already live.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flux_capacitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flux_capacitor

## Usage

```ruby
require 'flux_capacitor'

start = DateTime.parse('2017/08/14 00:00:00-000') # when do you want to start rolling out the feature
oldest = MyModel.first.created_at # If you are using active record finding your oldest item is pretty easy
# otherwise if you know the date of your first item, just use that
end_point = DateTime.parse('2017/09/14') # The point where the feature is fully rolled out/safe to remove the Flux Capacitor.
# This dictates how quickly the feature rolls out. If you are concerned about overloading a required service set this to farther in the future

FEATURE_1_CAPACITOR = Flux::Capacitor.new(start, end_point, oldest)

def controller_method
    model = MyModel.find(params[:id])
    if FEATURE_1_CAPACITOR.travel_to?(model.created_at)
        use_new_feature
    else
        use_old_feature
    end
end
```

If your feature doesn't map well to something where you have a date for each piece of content you can still use flux capacitor. It can also take strings and distribute them evenly over your rollout period using the murmur3 hashing algorithm.
```ruby
require 'flux_capacitor'
start = DateTime.parse('2017/08/14 00:00:00-000') # when do you want to start rolling out the feature
end_point = DateTime.parse('2017/09/14') # when do you want the rollout to finish

# NOTE: We don't need an oldest date when using strings
FEATURE_1_CAPACITOR = Flux::Capacitor.new(start, end_point)

def controller_method
    model = MyModel.find(params[:id])
    if FEATURE_1_CAPACITOR.travel_to?(model.uuid) # Any string will work here
        use_new_feature
    else
        use_old_feature
    end
end
```

One note about using the string hashing method, new content could get the old feature for a while.

### Testing

In order to test your code while migrating from one form to the other you can replace `Flux::Capacitor` with `Flux::Truthy` or `Flux::Falsy` They both expose the same API as a regular Capacitor but they `travel_to?` method will always return `true` and `false` respectively.

When working with rails you can do something like this:
```ruby
start = DateTime.parse('2017/08/14 00:00:00-000')
end_point = DateTime.parse('2017/09/14')
oldest = MyModel.first.created_at
FEATURE_1_CAPACITOR = Rails.env.test? ? Flux::Falsy.new : Flux::Capacitor.new(start, end_point, oldest)
```

This will make it so for your tests everything will be treated as before.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/raphaeleidus/flux_capacitor.
