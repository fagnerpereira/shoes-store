require 'rufus-scheduler'

rufus = Rufus::Scheduler.singleton

rufus.every '1m' do
  Webhooks::ProcessJob.perform_later
end
