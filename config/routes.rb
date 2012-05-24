Rails.application.routes.draw do
  scope :module => :datajam do
    scope :module => :datacard do
      
    end
  end

  namespace :admin do
    resources :mappings
  end
end
