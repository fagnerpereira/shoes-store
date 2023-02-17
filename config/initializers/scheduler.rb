require 'rufus-scheduler'

rufus = Rufus::Scheduler.singleton

rufus.every '10s' do
  Webhooks::ProcessJob.perform_later
end
