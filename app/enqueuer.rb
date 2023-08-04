# require 'redis'
require_relative 'importer'

class Enqueuer
  def self.enqueue(file)
    Importer.perform_async(file)
  end
end
