module AWS
  class ELB
    module TaggedItem

      # Adds a single tag with an optional tag value.
      #
      #     # adds a tag with the key production
      #     resource.tag('production')
      #
      #     # adds a tag with the optional value set to production
      #     resource.tag('role', :value => 'webserver')
      #
      # @param [String] key The name of the tag to add.
      # @param [Hash] options
      # @option options [String] :value An optional tag value.
      # Unlike EC2 version, this returns nil
      def add_tag key, options = {}
        tags[key] = options[:value].to_s
      end
      alias_method :tag, :add_tag

      # Deletes all tags associated with this EC2 resource.
      # @return [nil]
      def clear_tags
        tags.clear
        nil
      end

      # Returns a collection that represents only tags belonging to
      # this resource.
      #
      # @example Manipulating the tags of an EC2 instance
      #   i = ec2.instances["i-123"]
      #   i.tags.to_h                  # => { "foo" => "bar", ... }
      #   i.tags.clear
      #   i.tags.stage = "production"
      #   i.tags.stage                 # => "production"
      #
      # @return [ResourceTagCollection] A collection of tags that
      #   belong to this resource.
      #
      def tags
        LoadBalancerTagCollection.new(self, :config => config)
      end

    end
  end
end
