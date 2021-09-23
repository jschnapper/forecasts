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
            email: 'admin@example.com'
          },
          {
            first_name: 'alice',
            last_name: 'alice',
            email: 'alice.alice@example.com'
          },
          {
            first_name: 'bob',
            last_name: 'bob',
            email: 'bob.bob@example.com'
          },
          {
            first_name: 'carl',
            last_name: 'carl',
            email: 'carl.carl@example.com'
          },
          {
            first_name: 'dave',
            last_name: 'dave',
            email: 'dave.dave@example.com'
          },
          {
            first_name: 'eve',
            last_name: 'eve',
            email: 'eve.eve@example.com'
          },
          {
            first_name: 'frank',
            last_name: 'frank',
            email: 'frank.frank@example.com'
          },
          {
            first_name: 'grace',
            last_name: 'grace',
            email: 'grace.grace@example.com'
          },
          {
            first_name: 'henry',
            last_name: 'henry',
            email: 'henry.henry@example.com'
          }
        ]
  
        existing_members = Member.all.pluck(:email)
        members.each do |member|
          if !existing_members.include?(member[:email])
            Member.create!(member)
          end
        end

        # add roles
        admin = Member.includes(:role).find_by(first_name: "admin")
        admin_role_id = Role.find_by(name: "admin").id
        if admin.role.nil?
          MemberRole.create(member_id: admin.id, role_id: admin_role_id)
        end

        # set admin password to something easy
        admin.password = "password"
        admin.save(validate: false)
  
        sql = <<-SQL.squish
          select memberships.*,
            members.email,
            members.id as new_member_id,
            teams.name as team_name,
            teams.id as new_team_id
          from memberships
          inner join members on members.id = memberships.member_id
          inner join teams on teams.id = memberships.team_id
        SQL
        existing_teams = Team.all
        existing_members = Member.all
        existing_memberships = Membership.find_by_sql(sql)
        memberships = [
          {
            team_name: 'development',
            member_email: 'admin@example.com'
          },
          {
            team_name: 'development',
            member_email: 'alice.alice@example.com'
          },
          {
            team_name: 'development',
            member_email: 'bob.bob@example.com'
          },
          {
            team_name: 'business',
            member_email: 'carl.carl@example.com'
          },
          {
            team_name: 'business',
            member_email: 'dave.dave@example.com'
          },
          {
            team_name: 'marketing',
            member_email: 'eve.eve@example.com'
          },
          {
            team_name: 'marketing',
            member_email: 'frank.frank@example.com'
          },
          {
            team_name: 'dev ops',
            member_email: 'grace.grace@example.com'
          },
          {
            team_name: 'dev ops',
            member_email: 'henry.henry@example.com'
          }
        ]
  
        memberships.each do |membership|
          exists = existing_memberships.detect do |field|
            field.email == membership[:member_email] && field.team_name == membership[:team_name]
          end

          if !exists
            member = existing_members.detect { |member| membership[:member_email] == member.email }
            team = existing_teams.detect { |team| membership[:team_name] == team.name }
            Membership.create(member_id: member.id, team_id: team.id) if member && team
          end
        end

        # seed monthly forecasts
        monthly_forecasts = [
          {
            date: '2021-07-01',
            total_hours: 180,
            holiday_hours: 8
          },
          {
            date: '2021-08-01',
            total_hours: 188
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
