require 'csv'
require 'pg'
require_relative 'create_tables'

class ExamsImporter
  def self.import_from_csv(file)
    conn = start_connection
    data = read_file(file)
    create_tables(conn)
    import_csv(conn, data)
    conn.close
  end

  def self.start_connection
    PG.connect(dbname: 'rebase_labs_data',
               user: 'user',
               password: 'password',
               host: 'rebase_db')
  end

  def self.read_file(file)
    csv_data = CSV.read(file, col_sep: ';')
    columns = csv_data.shift
    csv_data.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end
  end

  def self.import_csv(conn, data)
    data.each do |row|
      begin
        conn.exec_params('INSERT INTO patients(patient_cpf, patient_name, patient_email, patient_birthdate, patient_address,
                          patient_city, patient_state)
                          VALUES ($1, $2, $3, $4, $5, $6, $7)',
                         [row['cpf'], row['nome paciente'], row['email paciente'], row['data nascimento paciente'],
                          row['endereço/rua paciente'], row['cidade paciente'], row['estado patiente']])
      rescue PG::UniqueViolation
        puts 'Registro duplicado'
      end

      begin
        conn.exec_params('INSERT INTO doctors (doctor_crm, doctor_crm_state, doctor_name, doctor_email)
                          VALUES ($1, $2, $3, $4)',
                         [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']])
      rescue PG::UniqueViolation
        puts 'Registro duplicado'
      end

      begin
        conn.exec_params('INSERT INTO results (token_result, exam_date, patient_cpf, doctor_crm)
                          VALUES ($1, $2, $3, $4)',
                         [row['token resultado exame'], row['data exame'], row['cpf'], row['crm médico']])
      rescue PG::UniqueViolation
        puts 'Registro duplicado'
      end

      conn.exec_params('INSERT INTO exams (exam_type, exam_limits, exam_result, token_result)
                        VALUES ($1, $2, $3, $4)',
                       [row['tipo exame'], row['limites tipo exame'], row['resultado tipo exame'],
                        row['token resultado exame']])
    end
  end
end

ExamsImporter.import_from_csv('./data.csv')
