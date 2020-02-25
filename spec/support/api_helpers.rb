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
end
