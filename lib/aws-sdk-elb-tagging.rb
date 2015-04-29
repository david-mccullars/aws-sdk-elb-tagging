require 'aws-sdk-v1'
Dir[File.expand_path('../aws/elb/**/*.rb', __FILE__)].sort.each { |f| load f }
AWS::ELB::LoadBalancer.send(:include, AWS::ELB::TaggedItem)
AWS::ELB::LoadBalancerCollection.send(:include, AWS::ELB::FilteredCollection)
AWS::ELB::LoadBalancerCollection.send(:include, AWS::ELB::TaggedCollection)
