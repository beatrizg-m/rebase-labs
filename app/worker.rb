require 'redis'

redis = Redis.new(host: 'redis')

puts 'worker started'

while true
  value = redis.lpop('exams:import')
  sleep 1
  puts "a"
  # if value
  #   puts "Importing #{value}..."
  #   puts "Imported #{value}"
  # end
end
