class SearchService
  def initialize(params)
    @params = params
  end

  def call
    ThinkingSphinx.search ThinkingSphinx::Query.escape(@params[:query]) 
  end
end
