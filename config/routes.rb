Rails.application.routes.draw do
  if (Rails.env.development? || ENV["ENABLE_GRAPHIQL"])
    get '/', to: redirect('/graphiql')
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
