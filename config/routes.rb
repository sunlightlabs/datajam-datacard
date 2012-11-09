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
      post 'to_html', :on => :member
      post 'to_csv', :on => :member
    end
    resources :mapping_data
    resources :csv_data

    resources :data_sets do
      resources :cards, :only => [:index, :new, :create]
    end

    resources :mappings, :only => [:index, :show] do
      resource :mapping_settings, :only => [:edit, :update], :as => 'settings', :path => 'settings'
    end
  end
end
