module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def headers
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def do_request(method, path, options = {})
    send method, path, options
  end
end
