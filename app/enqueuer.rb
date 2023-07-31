require 'redis'
class Enqueuer
  def self.enqueue(file_path)
    redis = Redis.new(host: 'redis')
    redis.rpush('exams:import', "#{rand(10...50)}")
  end
end
