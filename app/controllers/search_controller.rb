class SearchController < ApplicationController
  authorize_resource class: false

  def index
    @result = SearchService.call(
      query: params[:query],
      resource: params[:resource]
    )
  end
end
