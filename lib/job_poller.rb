class JobPoller
  def run
    job = Job.where("local_url IS NULL").find(:first, :lock => true)
    job.run if job
  end
end
