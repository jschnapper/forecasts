# frozen_string_literal: true

namespace :development do
  desc 'Seed development data'
  task seed: :environment do
    puts "Starting seeding..."
    begin
      ActiveRecord::Base.transaction do
        # Create fields
        fields = [
          { 
            name: 'pto', 
            description: 'paid time off',
            default: true
          },
          { 
            name: 'holiday', 
            description: 'Holiday',
            default: true
          },
          { 
            name: 'Other', 
            description: 'Anything not covered by the other fields',
            default: true
          },
          {
            name: 'project 1',
            code: '001',
            description: 'Project 1 charge code'
          },
          {
            name: 'project 2',
            code: '002',
            description: 'Project 2 charge code'
          }
        ]
  
        existing_fields = Field.all.pluck(:name)
        fields.each do |field|
          if !existing_fields.include?(field[:name].downcase)
            Field.create!(field)
          end
        end
  
        teams = [
          {
            name: 'development',
            description: 'developer team'
          },
          {
            name: 'business',
            description: 'business team'
          },
          {
            name: 'marketing',
            description: 'marketing team'
          },
          {
            name: 'dev ops',
            description: 'dev ops team'
          },
        ]
  
        existing_teams = Team.all.pluck(:name)
        teams.each do |team|
          if !existing_teams.include?(team[:name])
            Team.create!(team)
          end
        end
  
        existing_team_fields = TeamField.all
  
        # create team fields
        Team.all.each do |team|
          Field.all.each do |field|
            exists = existing_team_fields.detect do |team_field|
              team_field.team_id == team.id && team_field.field_id == field.id
            end
            TeamField.create(team_id: team.id, field_id: field.id) unless exists
          end
        end
  
        # create members
        members = [
          {
            first_name: 'admin',
            last_name: 'admin',
            email: 'admin@example.com',
            team_id: Team.find_by(name: 'development').id,
            role_id: Role.find_by(name: 'admin').id
          },
          {
            first_name: 'alice',
            last_name: 'alice',
            email: 'alice.alice@example.com',
            team_id: Team.find_by(name: 'development').id,
            role_id: Role.find_by(name: 'manager').id
          },
          {
            first_name: 'bob',
            last_name: 'bob',
            email: 'bob.bob@example.com',
            team_id: Team.find_by(name: 'development').id
          },
          {
            first_name: 'carl',
            last_name: 'carl',
            email: 'carl.carl@example.com',
            team_id: Team.find_by(name: 'business').id
          },
          {
            first_name: 'dave',
            last_name: 'dave',
            email: 'dave.dave@example.com',
            team_id: Team.find_by(name: 'business').id
          },
          {
            first_name: 'eve',
            last_name: 'eve',
            email: 'eve.eve@example.com',
            team_id: Team.find_by(name: 'marketing').id
          },
          {
            first_name: 'frank',
            last_name: 'frank',
            email: 'frank.frank@example.com',
            team_id: Team.find_by(name: 'marketing').id
          },
          {
            first_name: 'grace',
            last_name: 'grace',
            email: 'grace.grace@example.com',
            team_id: Team.find_by(name: 'dev ops').id
          },
          {
            first_name: 'henry',
            last_name: 'henry',
            email: 'henry.henry@example.com',
            team_id: Team.find_by(name: 'dev ops').id
          }
        ]
  
        existing_members = Member.all.pluck(:email)
        members.each do |member|
          if !existing_members.include?(member[:email])
            Member.create!(member)
          end
        end

        # set passwords to something easy
        admin = Member.find_by(first_name: 'admin')
        admin.password = "password"
        admin.save(validate: false)

        alice = Member.find_by(first_name: 'alice')
        alice.password = "password"
        alice.save(validate: false)

        holidays = [
          {
            name: "Independence Day",
            date: "2021-07-04"
          },
          {
            name: "Labor Day",
            date: "2021-09-06"
          }
        ]

        existing_holidays = Holiday.all.pluck(:name)
        holidays.each do |holiday|
          if !existing_holidays.include?(holiday[:name]&.downcase)
            Holiday.create!(holiday)
          end
        end
  
        # seed monthly forecasts
        monthly_forecasts = [
          {
            date: '2021-07-01'
          },
          {
            date: '2021-08-01'
          },
          {
            date: '2021-09-01'
          },
          {
            date: '2021-10-01'
          }
        ]

        existing_forecasts = MonthlyForecast.all.pluck(:date).map { |date| date.strftime('%Y-%m-%d') }
        monthly_forecasts.each do |forecast|
          MonthlyForecast.create(forecast) unless existing_forecasts.include?(forecast[:date])
        end
      end
    rescue StandardError => exception
      puts exception.message
      puts "=== FAILURE: did not complete seeding data ==="
    else
      puts "=== SUCCESS: Development data seeding complete ==="
    end
  end 
end
