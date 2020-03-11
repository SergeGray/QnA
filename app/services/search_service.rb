class SearchService
  RESOURCES = %w[Question Answer Comment User].freeze

  def self.call(query: , resource: nil)
    klass = RESOURCES.include?(resource) ? resource.constantize : ThinkingSphinx
    escaped_query = ThinkingSphinx::Query.escape(query)
    klass.search escaped_query
  end
end
