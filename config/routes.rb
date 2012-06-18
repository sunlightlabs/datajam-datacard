Rails.application.routes.draw do
  scope :module => :datajam do
    scope :module => :datacard do
      
    end
  end

  namespace :admin do
    resources :cards
    resources :mappings, :only => [:index, :show] do
      resources :mapping_requests, :only => [:new, :create], :path => ':endpoint_id/requests', :as => :requests
      resources :mapping_responses, :only => [:show], :as => :responses
    end
  end
end
