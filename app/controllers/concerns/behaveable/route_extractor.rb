# frozen_string_literal: true

module Behaveable
  module RouteExtractor
    # Generate url location.
    #
    # ==== Parameters
    # * <tt>behaveable</tt> - Behaveable object.
    # * <tt>resource</tt>   - Resource object. (member routes).
    #
    # ==== Returns
    # * <tt>Route</tt> - Url location.
    def extract(behaveable: nil, resource: nil, format: :html)
      location_url = location_url(behaveable: behaveable, resource: resource)
      return regular(location_url: location_url, resource: resource, format: format) unless behaveable

      location_url = location_url(behaveable: behaveable, resource: resource)
      nested(location_url: location_url, behaveable: behaveable, resource: resource, format: format)
    end

    private

    def location_url(behaveable: nil, resource: nil) # rubocop:disable Metrics/MethodLength
      resource_name   = resource_name_from(resource)
      behaveable_name = behaveable_name_from(behaveable)

      url = behaveable ? "#{behaveable_name}_#{resource_name}_url" : "#{resource_name}_url"

      case params[:action]
      when "edit"
        "edit_#{url}"
      when "new"
        "new_#{url}"
      else
        url
      end
    end

    # Handle non-nested url location.
    #
    # ==== Parameters
    # * <tt>location_url</tt> - Url route as string.
    # * <tt>resource</tt>     - Resource object.
    #
    # ==== Returns
    # * <tt>Route</tt> - Url location.
    def regular(location_url:, resource:, format: :html)
      return send(location_url, format: format) if resource.nil? || resource.id.nil?

      send(location_url, resource, format: format)
    end

    # Handle nested url location.
    #
    # ==== Parameters
    # * <tt>location_url</tt> - Url route as string.
    # * <tt>behaveable</tt>   - Behaveable object.
    # * <tt>resource</tt>     - Resource object.
    #
    # ==== Returns
    # * <tt>Route</tt> - Url location.
    def nested(location_url:, behaveable:, resource:, format: :html)
      return send(location_url, behaveable, format: format) if resource.nil? || resource.id.nil?

      send(location_url, behaveable, resource, format: format)
    end

    # Get resource name from params.
    #
    # ==== Parameters
    # * <tt>params</tt> - ApplicationController's params.
    #
    # ==== Returns
    # * <tt>String</tt> - Resource name (singular or plural).
    def resource_name_from(resource)
      inflection = resource ? "singular" : "plural"
      params[:controller].split("/").last.send("#{inflection}ize")
    end

    # Get behaveable class name.
    #
    # ==== Parameters
    # * <tt>behaveable</tt> - Behaveable object.
    #
    # ==== Returns
    # * <tt>String</tt> - Behaveable class snake case name or nil.
    def behaveable_name_from(behaveable)
      return unless behaveable

      behaveable.class.name.underscore
    end
  end
end
