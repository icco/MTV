class JobPoller
  def run
    loop do
      job = Job.where("local_url IS NULL").find(:first, :lock => true)
      next unless job
      job.run
    end
  end
end
