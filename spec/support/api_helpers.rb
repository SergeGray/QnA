module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def headers
    { 'ACCEPT' => 'application/json' }
  end

  def do_request(method, path, options = {})
    send method, path, options
  end

  def resource_response(json, resource)
    json.find { |entry| entry['id'] == resource.id }
  end
end
