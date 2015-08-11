require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Resource Match', type: [:api, :legacy_api] do
  include_context 'resource pool'

  let(:admin_auth_header) { admin_headers['HTTP_AUTHORIZATION'] }
  authenticated_request

  put '/v2/resource_match' do
    example 'List all matching resources' do
      explanation 'This endpoint matches given resource SHA/filesize pairs against the Cloud Controller cache,
        and reports the subset which describes already existing files.
        This is usually used to avoid uploading duplicate files when
        pushing an app which has only been partially changed.'
      @resource_pool.add_directory(@tmpdir)
      resources = [@descriptors.first] + [@dummy_descriptor]
      encoded_resources = MultiJson.dump(resources, pretty: true)
      client.put '/v2/resource_match', encoded_resources, headers
      expect(status).to eq(200)
    end
  end
end
