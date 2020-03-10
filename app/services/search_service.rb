class SearchService
  RESOURCES = %w[Question Answer Comment User].freeze

  def initialize(params)
    @params = params
  end

  def call
    searchable = if RESOURCES.include?(@params[:resource])
                   @params[:resource].constantize
                 else
                   ThinkingSphinx
                 end

    searchable.search ThinkingSphinx::Query.escape(@params[:query])
  end
end
