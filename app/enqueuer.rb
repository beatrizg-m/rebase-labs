require 'redis'
class Enqueuer
  def self.enqueue(file_path)
    redis = Redis.new(host: 'redis')
    redis.rpush('exams:import', "#{rand(10...50)}")
    # redis.set("mykey", "hello world")
    # ExamsImporter.import_from_csv(file_path)
  end
end
