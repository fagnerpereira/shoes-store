require 'test_helper'

class GraphqlTest < ActionDispatch::IntegrationTest
  test 'should query' do
    post '/graphql', params:  {"query"=>"query {\n  salesCharts {\n    byStores\n  }\n}", "variables"=>nil, "graphql"=>{"query"=>"query {\n  salesCharts {\n    byStores\n  }\n}", "variables"=>nil}}

  end
end
