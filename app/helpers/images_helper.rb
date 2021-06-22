# frozen_string_literal: true

module ImagesHelper
  class RouteHelperError < StandardError; end

  def nested_helper_url(resource_name:, action: nil, behaveable: nil, resource: nil)
    location_url = location_url(resource_name: resource_name, action: action, behaveable: behaveable,
                                resource: resource)
    return regular(location_url: location_url, resource: resource) unless behaveable

    nested(location_url: location_url, behaveable: behaveable, resource: resource)
  end

  private

  def regular(location_url:, resource: nil)
    return send(location_url) unless resource

    send(location_url, resource)
  end

  def nested(location_url:, behaveable:, resource: nil)
    return send(location_url, behaveable) unless resource

    send(location_url, behaveable, resource)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength

  def location_url(resource_name:, action: nil, behaveable: nil, resource: nil)
    inflected_name = resource_name_inflection(resource_name: resource_name, resource: resource)
    behaveable_name = behaveable_name_from(behaveable) # Always singular

    url = behaveable ? "#{behaveable_name}_#{inflected_name}_url" : "#{inflected_name}_url"

    case action&.to_sym
    when :edit
      raise RouteHelperError, "Edit Route Need a Resource" unless resource

      "edit_#{url}"
    when :new
      raise RouteHelperError, "New Route Need a Resource" unless resource
      raise RouteHelperError, "Persisted Resource For New Route" if resource_persisted?(resource)

      "new_#{url}"
    else
      url
    end
  end

  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength

  def resource_name_inflection(resource_name:, resource:)
    inflection = resource ? "singular" : "plural"
    resource_name.send("#{inflection}ize")
  end

  def behaveable_name_from(behaveable)
    return unless behaveable

    behaveable.class.name.underscore
  end

  def resource_persisted?(resource)
    return resource.persisted? if resource.respond_to?(:persisted?)

    !resource.id.nil?
  end
end
