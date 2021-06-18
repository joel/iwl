# frozen_string_literal: true

module Behaveable
  module ResourceFinder
    # Get the behaveable object.
    #
    # ==== Returns
    # * <tt>ActiveRecord::Model</tt> - Behaveable instance object.
    def behaveable
      klass, param = behaveable_class
      klass&.find(params[param.to_sym])
    end

    private

    # Lookup behaveable class.
    #
    # ==== Returns
    # * <tt>Response</tt> - Behaveable class object or nil if not found.
    def behaveable_class
      params.each do |name, _value|
        if /(.+)_id$/.match?(name)
          model = name.match(%r{([^/.]*)_id$})
          return model[1].classify.constantize, name
        end
      end
      nil
    end
  end
end
