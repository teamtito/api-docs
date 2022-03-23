def massage_name(name)
  name.titleize.
    sub("Checkin", "Check-in").
    sub("Opt In", "Opt-in").
    sub("Rsvp", "RSVP")
end

def set_version(version)
  @version = version
  @version_as_string = "%0.1f" % version
end

def set_resource(resource, slug: false)
  @resource = resource
  @slug = slug
end

def get_locals
  {
    version: @version,
    resource: @resource,
    resource_name: @resource.to_s.singularize,
    resource_plural: @resource.to_s,
    indefinite_article: @resource.to_s =~ /^([aeiou]|rsvp)/ ? "an" : "a"
  }
end

def get_base
  return unless @version_as_string
  return unless @resource
  data[@version_as_string][@resource]
end

def icon_for(name)
  case name
  when :attributes
    "<i class=\"fa-regular fa-tags\"></i>"
  when :expansions
    "<i class=\"fa-regular fa-arrows-maximize\"></i>"
  when :index
    "<i class=\"fa-regular fa-files\"></i>"
  when :show
    "<i class=\"fa-regular fa-file\"></i>"
  when :create
    "<i class=\"fa-regular fa-file-plus\"></i>"
  when :update
    "<i class=\"fa-regular fa-file-pen\"></i>"
  when :delete
    "<i class=\"fa-regular fa-file-xmark\"></i>"
  end
end

def display_response(name, resource: nil, params: {})
  resource ||= @resource
  if data[@version_as_string].nil?
    raise "Don't understand version \"#{@version_as_string}\""
  end
  if data[@version_as_string][resource].nil?
    raise "Couldn't find resource \"#{resource}\" in #{@version_as_string}"
  end
  if data[@version_as_string][resource][name].nil?
    raise "Couldn't find resource \"#{name}.json\" in #{@version_as_string}.#{resource}"
  end
  json = data[@version_as_string][resource][name]
  if params.any?
    resource_name = resource.to_s.singularize
    if json[resource_name].is_a?(Hash)
      json = json.dup
      params.each do |key, value|
        json[resource_name][key] = value
        Array(json[resource_name][:translations]).each do |locale, translation|
          if translation.has_key?(key)
            translation[key] = value
          end
        end
      end
    end
  end
  json.delete(:locals)
  partial "includes/shared/json", locals: { json: json }
end

def list_write_attributes(*names)
  base = get_base
  if base.nil?
    "TODO: Couldn't find data"
    return
  end
  list_attributes(
    base.attributes.select { |name, hash|
      names.map(&:to_s).include?(name)
    },
    skip: :write_only
  )
end

def show_doc(type, overrides: {})
  base = get_base
  if base.nil?
    "TODO: Couldn't find data"
    return
  end
  locals = get_locals
  case type
  when :attributes
    if base.attributes
      concat partial(
        "includes/shared/crud/attributes",
        locals: locals.merge(
          attributes: base.attributes,
          title: massage_name(locals[:resource_name])
        )
      )
    else
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/attributes.json</code>"
    end
  when :expansions
    if base.attributes
      expansions = base.attributes.select { |name, hash| hash[:expandable] }
      expansions[:translations] = { description: "A list of every translated attribute for each locale setup for your event." } if base.attributes.any? { |name, hash| hash[:translated] }
      if expansions.any?
        concat partial(
          "includes/shared/crud/expansions",
          locals: locals.merge(
            expansions: expansions,
            title: massage_name(locals[:resource_name])
          )
        )
      else
        "TODO: No expansions to show in #{@version_as_string}/#{@resource}/expansions.json"
      end
    else
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/expansions.json</code>"
    end
  when :index
    if base["index"]
      concat partial(
        "includes/shared/crud/index",
        locals: locals.merge(
          path: overrides.dig(:path) || @resource,
          description: overrides.dig(:description),
          expansions: base.expansions
        )
      )
    else
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/index.json</code>"
    end
  when :show
    if base.show
      concat partial(
        "includes/shared/crud/show",
        locals: locals.merge(
          path: overrides.dig(:path) || @resource,
          description: overrides.dig(:description),
          expansions: base.expansions,
          title: massage_name(locals[:resource_name]),
          id_suffix: @slug ? "_slug" : "_id"
        )
      )
    else
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/show.json</code>"
    end
  when :create
    if base.create && base.create_params
      concat partial(
        "includes/shared/crud/create",
        locals: locals.merge(
          params: base.create_params,
          title: massage_name(locals[:resource_name])
        )
      )
    elsif base.create
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/create_params.json</code>"
    else
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/create.json</code>"
    end
  when :update
    if base["update"] && base.update_params
      concat partial(
        "includes/shared/crud/update",
        locals: locals.merge(
          params: base.update_params,
          title: massage_name(locals[:resource_name]),
          id_suffix: @slug ? "_slug" : "_id"
        )
      )
    elsif base["update"]
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/update_params.json</code>"
    else
      "TODO: missing <code>data/#{@version_as_string}/#{@resource}/update.json</code>"
    end
  when :delete
    concat partial(
      "includes/shared/crud/delete",
      locals: locals.merge(
        title: massage_name(locals[:resource_name]),
        id_suffix: @slug ? "_slug" : "_id"
      )
    )
  else
    "Unkown doc \"#{type}\""
  end
end

def get_url(path, host: true)
  full_path = if path =~ /^\//
      path
    elsif path.to_s =~ /:event_slug$/
      "/:account_slug/#{path.sub(/^events\//, "")}"
    elsif path.to_s =~ /^events/
      "/:account_slug/#{path}"
    else
      "/:account_slug/:event_slug/#{path}"
    end
  if host
    "#{config[:api_endpoint]}#{full_path}"
  else
    full_path
  end
end

def show_url(path, method: :get, params: {})
  url = get_url(path)
  case method
  when :get
    partial "includes/requests/get",
      locals: {
        url: url
      }
  when :post
    partial "includes/requests/post",
      locals: {
        url: url,
        parameters: params
      }
  when :patch
    partial "includes/requests/patch",
      locals: {
        url: url,
        parameters: params
      }
  when :delete
    partial "includes/requests/delete",
      locals: {
        url: url,
        parameters: params
      }
  end
end

def show_url_key(combined_path, descriptions: {}, skip: nil)
  skip = Array(skip)
  method, path = combined_path.to_s.split(" ")
  if path.nil?
    path = method
    method = "GET"
  end
  url = get_url(path, host: false)
  concat "`#{method} #{url}`\n\n"
  params = url.split("/").select { |p| p =~ /^:/ }.map { |p| p.sub(":", "") }
  if !skip.include?(:key)
    params.each do |param|
      description = descriptions[param.to_sym]
      description ||= if param.to_s =~ /_id$/
          "the `id` of the `#{param.to_s.sub("_id", "")}`"
        elsif param.to_s =~ /_slug$/
          if %w[account_slug event_slug].include?(param.to_s)
            "the `slug` of the `#{param.to_s.sub("_slug", "")}`."
          else
            "the `slug` (or `id`) of the `#{param.to_s.sub("_slug", "")}`."
          end
        end
      concat "* `#{param}` - #{description}\n"
    end
  end
  nil
end

def list_attributes(attributes, skip: [])
  skip = Array(skip)
  concat "<ul class=\"attribute-list\">\n"
  attributes.reject { |name, hash| %w[id slug created_at updated_at].include?(name) || hash[:ignore] }.each do |name, hash|
    list_attribute(name, hash, skip: skip)
  end
  common_attributes = attributes.select { |name| %w[id slug created_at updated_at].include?(name) }
  if common_attributes.any?
    concat "<li class=\"separator\">Common attributes:</li>"
    common_attributes.sort_by { |name, _| %w[id slug created_at updated_at].index(name) }.each do |name, hash|
      list_attribute(name, hash, skip: skip)
    end
  end
  concat "</ul>\n"
end

def list_attribute(name, hash, skip:)
  concat "<li><div>"
  concat "<code class=\"name\">#{name}</code>"
  concat "<span class=\"type\">#{hash["type"]}</span>" if hash["type"].present?
  concat "<span class=\"read-only\">read only</span>" if hash[:read_only] && !skip.include?(:read_only)
  concat "<span class=\"write-only\">write only</span>" if hash[:write_only] && !skip.include?(:write_only)
  concat "<span class=\"required\">required</span>" if hash[:required] && !skip.include?(:required)
  concat "<span class=\"translated\">translated</span><span class=\"translated-note\">*</span>" if hash[:translated] && !skip.include?(:translated)
  concat "<i class=\"fa-regular fa-flask targetted-feature\"></i>" if hash[:targetted_feature]
  if hash[:expandable] && !skip.include?(:expandable)
    concat "<span class=\"expandable\">expandable</span>"
  end
  concat "</div>"
  descriptions = [hash[:description]].compact
  if hash[:targetted_feature]
    descriptions << "This requires the `#{hash[:targetted_feature]}` private beta feature."
  end
  if hash[:expandable] && !skip.include?(:expandable)
    descriptions << "This attribute is hidden by default but you can expand it using `?expand=#{name}`."
  end
  if data[@version_as_string][name]
    descriptions << "See <a href=\"##{name}\">#{name}</a>."
  end
  concat "<div class=\"attribute-description\">#{descriptions.join(" ").gsub(/`([^`]+)`/, '<code>\1</code>')}</div>" if descriptions.any?
  if hash[:expand_ids]
    concat "<div class=\"sub-attribute\">"
    concat "<code class=\"name\">#{name}_ids</code>"
    concat "<span class=\"type\">integer array</span>"
    concat "<span class=\"expandable\">expandable</span>" unless skip.include?(:expandable)
    concat "</div>"
    concat "<div class=\"sub-attribute-description\">"
    concat "Or use `#{name}_ids` and just get an array of `id` values.".gsub(/`([^`]+)`/, '<code>\1</code>')
    concat "</div>"
  end
  if hash[:expand_slugs]
    concat "<div class=\"sub-attribute\">"
    concat "<code class=\"name\">#{name}_slugs</code>"
    concat "<span class=\"type\">string array</span>"
    concat "<span class=\"expandable\">expandable</span>" unless skip.include?(:expandable)
    concat "</div>"
    concat "<div class=\"sub-attribute-description\">"
    concat "Or use `#{name}_slugs` and just get an array of `slug` values.".gsub(/`([^`]+)`/, '<code>\1</code>')
    concat "</div>"
  end
  concat "</li>\n"
end

def list_required_attributes(version, resource)
  version_as_string = "%0.1f" % version
  if data[version_as_string].nil?
    raise "Don't understand version \"#{version_as_string}\""
  end
  if data[version_as_string][resource].nil?
    raise "Couldn't find resource \"#{resource}\" in #{version_as_string}"
  end
  if data[version_as_string][resource].attributes.nil?
    raise "Couldn't find \"attributes.json\" in #{version_as_string}.#{resource}"
  end
  list = data[version_as_string][resource].attributes.select { |_, hash| hash["required"] }
  concat "### Required attributes\n"
  list_attributes list, skip: [:required, :translated]
  nil
end

def show_expand_example(path, expansions)
  url = get_url(path, host: false)
  "`GET #{url}?expand=#{expansions.slice(0, 2).join(",")}`"
end

def beta_feature(title)
  partial "includes/shared/beta_feature", locals: { title: title }
end
