# AWS ELB tagging support

As of version 1.52 of the AWS sdk, there is not full support for tagging
built in.  However, the API itself has (limited) support.  This gem
provides temporary access to load balancer tagging in line with the way
tagging is implemented in EC2.

## Installation

Add this line to your application's Gemfile:

    gem 'aws-sdk-elb-tagging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws-sdk-elb-tagging

## Usage

    elb.load_balancers.with_tag('atag', 'avalue').tagged('some_key').tagged_values('A', 'B')
    elb.load_balancers.filter('tag:t1', 'v1').filter('tag-key', 't1').filter('tag-value', 'v1')

    a_load_balancer.tags.to_h    => { 't1' => 'v1', 't2' => 'v2' }
    a_load_balancer.tags.set(:t3 => 'v3')
    a_load_balancer.tags.delete(:t1)
    a_load_balancer.tags.to_h    => { 't2' => 'v2', 't3' => 'v3' }
    a_load_balancer.tags.t2      => 'v2'
    a_load_balancer.tags['t3']   => 'v3'
    a_load_balancer.tags['t3'] = 'new_v3'

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws-sdk-elb-tagging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
