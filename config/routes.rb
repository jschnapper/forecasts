# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  devise_for :members, path: 'manage/auth', controllers: { sessions: "members/sessions" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Root is the forecast submissions form for the month
  root to: 'submit_forecasts#new'

  # submitting forecasts
  # /forecasts
  get '/forecasts', to: 'submit_forecasts#new', as: :new_forecast
  post '/forecasts', to: 'submit_forecasts#create', as: :create_forecast
  # /forecasts/team_name/year/month
  get '/forecasts/(:team_name)/(:year)/(:month)', to: 'submit_forecasts#new', as: :new_team_forecast
  get '/forecast/teams/(:team_name)', to: 'submit_forecasts#index', as: :team_forecasts

  scope :manage do
    resources :teams, param: :team_name
    resources :members, :fields, :holidays, :monthly_forecasts
    scope '/teams/:team_name' do
      get '/forecasts', to: 'forecasts#index'
      get '/forecast/(:year)/(:month)', to: 'forecasts#show', as: :forecast
      put '/forecast/status', to: 'forecast_status#update', as: :forecast_status
      get '/members', to: 'members#team_members', as: :team_members
      post '/forecast/export', to: 'exports#create', as: :export_forecast
      put '/membership', to: 'memberships#update', as: :delete_membership
      resource :fields, controller: :team_fields, as: :team_fields, except: :index
    end
  end

  get '/send_reminder/(:team_name)', to: 'reminders#new', as: :send_reminder
  post '/send_reminder/(:team_name)', to: 'reminders#create', as: :send_reminders

  scope 'admin' do
    get '/', to: 'admins#index', as: :admin_home
  end
end
