SockChat::Application.routes.draw do
  root to: 'chat#index'
  get '/:id' => 'chat#index'
  get '/chat/:id' => 'chat#chat'
end
