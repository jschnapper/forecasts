class ReminderMailerPreview < ActionMailer::Preview
  def reminder
    ReminderMailer.reminder(Member.second, MonthlyForecast.last, "Make sure you submit soon!")
  end
end