class JobPoller
  def run
    loop do
      job = Job.find(:first, :lock => true)
      next unless job
      job.run
      job.delete
    end
  end
end
