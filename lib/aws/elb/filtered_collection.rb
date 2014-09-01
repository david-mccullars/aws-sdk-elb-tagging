module AWS
  class ELB

    module FilteredCollection

      def initialize options = {}
        @filters = options[:filters] || []
        super
      end

      # Specify one or more criteria to filter elastic IP addresses by.
      # A subsequent call to #each will limit the results returned
      # by provided filters.
      #
      #   * Chain multiple calls of #filter together to AND multiple conditions
      #     together.
      #   * Supply multiple values to a singler #filter call to OR those
      #     value conditions together.
      #   * '*' matches one or more characters and '?' matches any one
      #     character.
      #
      def filter filter_name, *values
        @filters = @filters.dup
        @filters << { :name => filter_name, :values => values.flatten }
        self
      end

      def each(&block)
        super do |lb|
          yield(lb) if matches_filters?(lb)
        end
      end

      private

      # The ELB tagging api does not support filters on describe_load_balancers, so
      # we have to filter after the fact.

      def matches_filters?(lb)
        tags = lb.tags.to_h
        @filters.all? { |f| matches_filter?(tags, f) }
      end

      def matches_filter?(tags, f)
        case f[:name]
        when 'tag-key'
          f[:values].any? { |k| tags.has_key? k.to_s }
        when 'tag-value'
          f[:values].any? { |v| tags.has_value? v.to_s }
        when /^tag:(.*)/
          f[:values].map(&:to_s).include? tags[$1]
        else
          raise "Unsupported filter for load balancers: #{f[:name].inspect}"
        end
      end

    end

  end
end
