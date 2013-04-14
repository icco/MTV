require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Job Model" do
  it 'can construct a new instance' do
    @job = Job.new
    refute_nil @job
  end
end
