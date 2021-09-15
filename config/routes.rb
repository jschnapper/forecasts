# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Root is the forecast submissions form for the month
  root to: 'submit_forecasts#new'

  # submitting forecasts
  # /forecasts
  get '/forecasts', to: 'submit_forecasts#new', as: :new_forecast
  post '/forecasts', to: 'submit_forecasts#create', as: :create_forecast
  # /forecasts/team_name/year/month
  get '/forecasts/(:team_name)/(:year)/(:month)', to: 'submit_forecasts#new', as: :new_team_forecast

  # manager responsibilities
  # /manage/team-name
  # /manage/team-name/members
  # /manage/team-name/forecasts
  # /manage/team-name/forecasts/year/month
  # /manage/team-name/notifications
  # /manage/team-name/fields
  scope 'manage' do
    scope ':team_name' do
      # manage team
      get '/', to: 'teams#show'
      get '/edit', to: 'teams#edit'
      put '/', to: 'teams#update'

      # manage individual team members
      resources :members, as: :team_members

      # manage forecasts
      get '/forecasts', to: 'forecasts#index'
      get '/forecasts/current', to: 'forecasts#show'
      get '/forecasts/:year/:month', to: 'forecasts#show', as: :forecast

      # manage emails/notifications
      resource :notifications

      # manage fields
      resource :fields, as: :team_fields
    end
  end

  # admin
  # /admin/teams
  # /admin/members
  # /admin/holidays
  # /admin/fields
  # /admin/monthly_forecasts
  # /admin/jobs
  scope 'admin' do
    get '/', to: 'admins#index', as: :admin_home
    resources :teams
    resources :members, as: :members
    resources :holidays
    resources :monthly_forecasts
    resources :fields, as: :fields
    get '/team_fields/:team_id', to: 'team_fields#new', as: :new_fields_for_team
    post '/team_fields', to: 'team_fields#create', as: :fields_for_teams
    delete '/team_fields/:id', to: 'team_fields#destroy', as: :delete_field_for_team
    resources :jobs
  end
end
