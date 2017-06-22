# FluxCapacitor

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/flux_capacitor`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

pivot = DateTime.parse('2017/08/14 00:00:00-000') # Everything after this date will have the new feature. This is the point in time when your new feature will start to go live
oldest = MyModel.first.created_at # If you are using active record finding your oldest item is pretty easy, otherwise if you know the date of your first item, just use that
end_point = DateTime.parse('2017/09/14') # At this point the feature should be fully rolled out and it is safe to remove the Flux Capacitor. This dictates how quickly the feature rolls out. If you are concerned about overloading a required service set this to farther in the future to lower load

FEATURE_1_CAPACITOR = Flux::Capacitor.new(pivot, end_point, oldest)

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
pivot = DateTime.parse('2017/08/14 00:00:00-000') # when do you want to start rolling out the feature
end_point = DateTime.parse('2017/09/14') # when do you want the rollout to finish

# NOTE: We don't need an oldest date when using strings
FEATURE_1_CAPACITOR = Flux::Capacitor.new(pivot, end_point)

def controller_method
    model = MyModel.find(params[:id])
    if FEATURE_1_CAPACITOR.travel_to?(model.uuid)
        use_new_feature
    else
        use_old_feature
    end
end
```

One note about using the string hashing method, new content could get the old feature for a while.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/raphaeleidus/flux_capacitor.
