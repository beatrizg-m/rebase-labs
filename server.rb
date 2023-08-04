require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'app/enqueuer'
require_relative 'app/importer'

def create_connection
  PG.connect(dbname: 'rebase_labs_data',
    user: 'user',
    password: 'password',
    host: 'rebase_db'
  )
end

get '/exams' do
  File.open('index.html')
end

get '/tests' do
  conn = create_connection
  tokens = conn.exec('SELECT token_result FROM results')
  data = tokens.map do |row_token_result|
    data = conn.exec('SELECT e.*, r.*,
      p.patient_cpf, p.patient_name, p.patient_email, p.patient_birthdate,
        d.doctor_crm, d.doctor_crm_state, d.doctor_name
      FROM exams e
      JOIN results r ON e.token_result = r.token_result
      JOIN patients p ON r.patient_cpf = p.patient_cpf
      JOIN doctors d ON r.doctor_crm = d.doctor_crm
      WHERE r.token_result = $1', [row_token_result["token_result"]])
    {
        result_token: row_token_result["token_result"],
        result_date: data[0]["exam_date"],
        cpf: data[0]["patient_cpf"],
        name: data[0]["patient_name"],
        email: data[0]["patient_email"],
        birthdate: data[0]["patient_birthdate"],
        doctor: {
          crm: data[0]["doctor_crm"],
          crm_state: data[0]["doctor_crm_state"],
          name: data[0]["doctor_name"],
        },
        tests: data.map do |exam|
          {
            "type" => exam["exam_type"],
            "limits" => exam["exam_limits"],
            "result" => exam["exam_result"]
          }
        end
       }
  end
  content_type :json
  data.to_json
end

get '/tests/:token' do |token|
  conn = create_connection

  data = conn.exec('SELECT e.*, r.*,
    p.patient_cpf, p.patient_name, p.patient_email, p.patient_birthdate,
      d.doctor_crm, d.doctor_crm_state, d.doctor_name
    FROM exams e
    JOIN results r ON e.token_result = r.token_result
    JOIN patients p ON r.patient_cpf = p.patient_cpf
    JOIN doctors d ON r.doctor_crm = d.doctor_crm
    WHERE r.token_result = $1', [token])

  content_type :json
  {
    result_token: token,
    result_date: data[0]["exam_date"],
    cpf: data[0]["patient_cpf"],
    name: data[0]["patient_name"],
    email: data[0]["patient_email"],
    birthdate: data[0]["patient_birthdate"],
    doctor: {
      crm: data[0]["doctor_crm"],
      crm_state: data[0]["doctor_crm_state"],
      name: data[0]["doctor_name"],
    },
    tests: data.map do |exam|
      {
        "type" => exam["exam_type"],
        "limits" => exam["exam_limits"],
        "result" => exam["exam_result"]
      }
    end
   }.to_json
end

get '/patient/:cpf' do |cpf|
  conn = create_connection

  data = conn.exec('SELECT * FROM patients WHERE patient_cpf = $1', [cpf])
  data.each { |row| puts row }
  ''
end

post '/import' do
  Importer.perform_async(params[:file])
  "Importado!"
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
