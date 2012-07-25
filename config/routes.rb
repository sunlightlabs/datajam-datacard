Rails.application.routes.draw do
  scope :module => 'datajam/datacard' do
    scope '/admin/plugins/datajam-datacard' do
      get '/install' => 'plugin#install'
      get '/uninstall' => 'plugin#uninstall'
      get '/refresh_assets' => 'plugin#refresh_assets'
    end
  end

  namespace :admin do
    resources :cards do
      resources :graphs, :except => [:edit, :update], :controller => :card_graphs
    end
    
    resources :mappings, :only => [:index, :show] do
      resource :mapping_settings, :only => [:edit, :update], :as => 'settings', :path => 'settings'
      resources :mapping_requests, :only => [:new, :create], :path => ':endpoint_id/requests', :as => :requests
      resources :mapping_responses, :only => [:show], :as => :responses do
        resources :cards_from_mapping_responses, :only => [:new, :create], :as => :cards, :path => 'cards'
      end
    end
  end
end
