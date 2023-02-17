require 'rufus-scheduler'

rufus = Rufus::Scheduler.singleton
rufus.every '5s' do
  Webhooks::ProcessJob.perform_later
end
