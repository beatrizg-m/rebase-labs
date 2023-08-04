require 'sidekiq'
require_relative 'exams_importer'

class Importer
  include Sidekiq::Worker

  def perform(file)
    ExamsImporter.import_from_csv(file)
    sleep 5
    "Imported #{file}"
  end
end
