require 'redis'
class Enqueuer
  def self.enqueue(file_path)
    ExamsImporter.import_from_csv(file_path)
  end
end
