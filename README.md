# rational_choice

Makes a fuzzy logic choice based on a continuum of values. For when a "yes or no" is not-quite-good-enough.

## Choice on one dimension of values

Primary use is for things like load balancing. Imagine you have a server handling 14 connections,
and you know that it can take about 20 maximum. When you decide whether to send the connection
number 17 to it, you want to take a little margin and only send that connection sometimes, to
balance the choices - so you want to use a softer bound (a bit of a fuzzy logic).

    will_accept_connection = RationalChoice::Dimension.new(20, 10) # ten connections is always safe
    if will_accept_connection.choose(server.current_connection_count + 1) # will give you a fuzzy choice
      server.accept(new_client)
    else
      ... # over capacity at the moment, try later
    end

This way the return value of `choose()` will be determined by the probability of the value being `true` - i.e.
how close it is to the upper bound. Values at or below the lower bound will always choose `false`. Values at
or above the upper bound will always choose `true`.

## Choice on multiple dimensions

Useful to give rational choices on multiple values, averaged together.

    num_clients = Dimension.new(200, 100)
    bandwidth = Dimension.new(2048, 1024)
    has_capacity = ManyDimensions.new(num_clients, bandwidth)
    
    will_accept_connection = has_capacity.choose(current_client_count, current_bandwidth)

## Contributing to rational_choice
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 WeTransfer. See LICENSE.txt for
further details.

