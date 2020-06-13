# HandlingQueue

Timed handling of elements of queue in separate threads.

## Installation

Add gem to your Gemfile using

	$ bundle add handling_queue

## Usage

Setting up handler:

	handling_queue = HandlingQueue.new(slice: 1, interval: 1) do |a|
	  # Handle `a` which is array of `HandlingQueue::Request`
      a.each { |e| e.re = e.obj * 2 } # It is necessar to assign `e.re`
    end

Adding elements to queue:

    handling_queue.handle(1) # Sleeps until handler called for this number, then => 2
    handling_queue.handle(2) # => 4
    handling_queue.handle(5) # => 10

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fizvlad/handling_queue.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
