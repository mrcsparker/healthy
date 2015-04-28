require 'singleton'
require 'pp'

module Healthy
  class Router
    class << self
      attr_accessor :routes
      
      # @param Hash r key should be class, value should be array of servers to run on
      def add(r)
        r.each { |klass, servers| add_route(klass, servers) }
      end
      
      def add_route(*route)
        @routes ||= Hash.new{|h, k| h[k] = {}}
        klass = route.first
        # this can be nil
        servers = route[1]
        @routes[normalized_name(klass)][:klass] = klass
        @routes[normalized_name(klass)][:servers] = servers
      end
      
      def normalized_name(klass)
        name = klass.class.name

        if klass.respond_to?(:display_name)
          name = klass.display_name
        elsif klass.respond_to?(:name)
          name = klass.name
        end

        name.downcase.gsub(' ', '')
      end
    end
  end
end