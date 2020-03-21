module ApplicationHelper
  GIST_RECEIVER = 'https://www.gonevis.com/toodartoo/embed/?media='.freeze

  def embed_gist(link)
    content_tag :iframe,
                '',
                src: "#{GIST_RECEIVER}#{link.url}",
                class: "gist-link-#{link.id}"
  end

  def resource_name(resource)
    resource.class.name.downcase
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)

    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
