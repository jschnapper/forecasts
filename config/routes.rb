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
      get '/members/new', to: 'members#new'
      post '/members', to: 'members#create'
      get '/members/:id', to: 'members#show'
      get '/members/edit', to: 'members#edit'
      put '/members/:id', to: 'members#update'
      delete '/members/:id', to: 'members#destroy'

      # manage forecasts
      get '/forecasts', to: 'forecasts#show'
      get '/forecasts/:year/:month', to: 'forecasts#show'

      # manage emails/notifications
      resource :notifications

      # manage fields
      resource :fields
    end
  end

  # admin
  # /admin/teams
  # /admin/members
  # /admin/holidays
  # /admin/fields
  # /admin/jobs
  scope 'admin' do
    resources :teams
    resources :members
    resources :holidays
    resources :fields
    resources :jobs
  end
end
