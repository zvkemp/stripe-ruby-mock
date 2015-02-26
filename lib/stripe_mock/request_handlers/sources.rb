module StripeMock
  module RequestHandlers
    module Sources

      def Cards.included(klass)
        klass.add_handler 'get /v1/customers/(.*)/sources', :retrieve_sources
        klass.add_handler 'post /v1/customers/(.*)/sources', :create_source
        klass.add_handler 'get /v1/customers/(.*)/sources/(.*)', :retrieve_source
        klass.add_handler 'delete /v1/customers/(.*)/sources/(.*)', :delete_source
        klass.add_handler 'post /v1/customers/(.*)/sources/(.*)', :update_source
      end

      def create_source(route, method_url, params, headers)
        route =~ method_url
        add_card_to(:customer, $1, params, customers)
      end

      def retrieve_sources(route, method_url, params, headers)
        route =~ method_url
        retrieve_object_cards(:customer, $1, customers)
      end

      def retrieve_source(route, method_url, params, headers)
        route =~ method_url
        customer = assert_existence :customer, $1, customers[$1]

        assert_existence :card, $2, get_card(customer, $2)
      end

      def delete_source(route, method_url, params, headers)
        route =~ method_url
        delete_card_from(:customer, $1, $2, customers)
      end

      def update_source(route, method_url, params, headers)
        route =~ method_url
        customer = assert_existence :customer, $1, customers[$1]

        card = assert_existence :card, $2, get_card(customer, $2)
        card.merge!(params)
        card
      end

    end
  end
end
