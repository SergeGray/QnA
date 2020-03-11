class SearchService
  RESOURCES = %w[Question Answer Comment User].freeze

  def self.call(query: '', resource: nil)
    klass = if RESOURCES.include?(resource)
              resource.constantize
            else
              ThinkingSphinx
            end

    escape_query = ThinkingSphinx::Query.escape(query)
    klass.search escape_query
  end
end
