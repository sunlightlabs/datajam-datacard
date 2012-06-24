Rails.application.routes.draw do
  scope :module => :datajam do
    scope :module => :datacard do
      
    end
  end

  namespace :admin do
    resources :cards
    resources :mappings, :only => [:index, :show] do
      resource :mapping_settings, :only => [:edit, :update], :as => 'settings', :path => 'settings'
      resources :mapping_requests, :only => [:new, :create], :path => ':endpoint_id/requests', :as => :requests
      resources :mapping_responses, :only => [:show], :as => :responses do
        resources :cards_from_mapping_responses, :only => [:new, :create], :as => :cards, :path => 'cards'
      end
    end
  end
end
