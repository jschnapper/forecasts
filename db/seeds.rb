# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create base roles
Role.create(
  [
    {
      name: 'Admin',
      description: 'Administrator for entire application and all teams'
    },
    {
      name: 'Manager',
      description: 'Team manager. Can only manage own team and see team related forecasts'
    },
    {
      name: 'Representative',
      description: 'Can manage members and fields for own team, but cannot see forecasts'
    }
  ]
)

# Create required fields
Field.create(
  [
    { 
      name: 'PTO',
      description: 'paid time off',
      default: true
    },
    { 
      name: 'Holiday',
      description: 'Holiday',
      default: true
    },
    { 
      name: 'Other',
      description: 'Anything not covered by the other fields. Trainings, etc.',
      default: true
    }
  ]
)
