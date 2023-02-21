module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    GROUP_BY = {
      'daily' => 'group_by_day',
      'weekly' => 'group_by_week',
      'monthly' => 'group_by_month'
    }.freeze
    DEFAULT_INTERVAL = 'daily'.freeze
    DEFAULT_FILTER = 7

    field :sales, [GraphQL::Types::JSON] do
      argument :filter, Integer, default_value: DEFAULT_FILTER
      argument :interval, String, default_value: DEFAULT_INTERVAL
    end

    field :sales_by_stores, [GraphQL::Types::JSON] do
      argument :filter, Integer, default_value: DEFAULT_FILTER
    end

    field :sales_by_products, [GraphQL::Types::JSON] do
      argument :filter, Integer, default_value: DEFAULT_FILTER
    end

    def sales(filter:, interval:)
      Sale.where(created_at: filter.days.ago..Time.current)
          .send(GROUP_BY[interval], :created_at)
          .sum(:price)
    end

    def sales_by_stores(filter:)
      Sale.joins(:store)
          .where(created_at: filter.days.ago..Time.current)
          .group('stores.name')
          .count
          .sort_by { |_, count| count }.reverse
    end

    def sales_by_products(filter:)
      Sale.joins(:product)
          .where(created_at: filter.days.ago..Time.current)
          .group('products.name')
          .count
          .sort_by { |_, count| count }.reverse
    end
  end
end
