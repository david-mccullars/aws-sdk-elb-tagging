module AWS
  class ELB

    # Represents the ELB tags associated with a single load balancer.
    #
    # @example
    #   lb = elb.load_balancers['abc123']
    #   lb.tags.to_h                  # => { "foo" => "bar", ... }
    #   lb.tags.clear
    #   lb.tags.stage = "production"
    #   lb.tags.stage                 # => "production"
    class LoadBalancerTagCollection

      include Core::Model
      include Enumerable

      # @api private
      def initialize(load_balancer, opts = {})
        @load_balancer_name = load_balancer.name
        super(opts)
      end

      # @return [String] The value of the tag with the given key, or
      #   nil if no such tag exists.
      #
      # @param [String or Symbol] key The key of the tag to return.
      def [](key)
        each { |k, v| return v if k == key.to_s }
        nil
      end

      # @return [Boolean] True if the resource has no tags.
      def empty?
        any?
      end

      # @param [String or Symbol] key The key of the tag to check.
      # @return [Boolean] True if the resource has a tag for the given key.
      def has_key?(key)
        any? { |k, v| k == key.to_s }
      end
      alias_method :key?, :has_key?
      alias_method :include?, :has_key?
      alias_method :member?, :has_key?

      # @param [String or Symbol] value The value to check.
      # @return [Boolean] True if the resource has a tag with the given value.
      def has_value?(value)
        any? { |k, v| v == value.to_s }
      end
      alias_method :value?, :has_value?

      # Changes the value of a tag.
      # @param [String or Symbol] key The key of the tag to set.
      # @param [String] value The new value.  If this is nil, the tag will
      #   be deleted.
      def []=(key, value)
        if value
          set(key => value)
        else
          delete(key)
        end
        nil # Unlike EC2 version, this does not return a Tag object
      end
      alias_method :store, :[]=

      # Adds a tag with a blank value.
      #
      # @param [String or Symbol] key The key of the new tag.
      def add(key)
        self[key] = ''
        nil # Unlike EC2 version, this does not return a Tag object
      end
      alias_method :<<, :add

      # Sets multiple tags in a single request.
      #
      # @param [Hash] tags The tags to set.  The keys of the hash
      #   may be strings or symbols, and the values must be strings.
      #   Note that there is no way to both set and delete tags
      #   simultaneously.
      def set(tags)
        tags = tags.map { |k, v| { :key => k.to_s, :value => v.to_s } }
        client.add_tags api_args.merge(:tags => tags)
      end
      alias_method :update, :set

      # Allows setting and getting individual tags through instance
      # methods.  For example:
      #
      #  tags.color = "red"
      #  tags.color         # => "red"
      def method_missing(m, *args)
        if m.to_s[-1,1] == "="
          self.send(:[]=, m.to_s[0...-1], *args)
        elsif args.empty?
          self[m]
        else
          super
        end
      end

      # Deletes the tags with the given keys (which may be strings
      # or symbols).
      def delete(*keys)
        return if keys.empty?
        keys = keys.map { |k, v| { :key => k.to_s } }
        client.remove_tags api_args.merge(:tags => keys)
      end

      # Removes all tags from the resource.
      def clear
        delete *map(&:first)
      end

      # @yield [key, value] The key/value pairs of each tag
      #   associated with the resource.  If the block has an arity
      #   of 1, the key and value will be yielded in an aray.
      def each(&blk)
        td = client.describe_tags(api_args)[:tag_descriptions]
        tags = td.detect { |t| t[:load_balancer_name] == @load_balancer_name } or return
        tags[:tags].each do |t|
          k, v = t.values_at(:key, :value).map(&:to_s)
          if blk.arity == 2
            yield(k, v)
          else
            yield([k, v])
          end
        end
        nil
      end
      alias_method :each_pair, :each

      # @return [Array] An array of the tag values associated with
      #   the given keys.  An entry for a key that has no value
      #   (i.e. there is no such tag) will be nil.
      def values_at(*keys)
        hash = to_h
        keys.map do |key|
          hash[key.to_s]
        end
      end

      private

      def api_args
        { :load_balancer_names => [@load_balancer_name] }
      end

    end

  end
end
