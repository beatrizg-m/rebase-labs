def create_tables(conn)
  conn.exec('DROP TABLE IF EXISTS patients CASCADE')
  conn.exec('DROP TABLE IF EXISTS doctors CASCADE')
  conn.exec('DROP TABLE IF EXISTS results CASCADE')
  conn.exec('DROP TABLE IF EXISTS exams CASCADE')
  conn.exec('CREATE TABLE IF NOT EXISTS patients(
      patient_id SERIAL PRIMARY KEY,
      patient_name VARCHAR(150) NOT NULL,
      patient_cpf VARCHAR(14) UNIQUE,
      patient_birthdate DATE NOT NULL,
      patient_email VARCHAR(150) NOT NULL,
      patient_address VARCHAR (250) NOT NULL,
      patient_city VARCHAR(100) NOT NULL,
      patient_state VARCHAR(100) NOT NULL)')

  conn.exec('CREATE TABLE IF NOT EXISTS doctors(
      doctor_id SERIAL PRIMARY KEY,
      doctor_name VARCHAR(150) NOT NULL,
      doctor_email VARCHAR(150) NOT NULL,
      doctor_crm VARCHAR(10) NOT NULL UNIQUE,
      doctor_crm_state VARCHAR(2) NOT NULL)')

  conn.exec('CREATE TABLE IF NOT EXISTS results(
      token_result VARCHAR(6) PRIMARY KEY,
      exam_date DATE NOT NULL,
      patient_cpf VARCHAR(14),
      doctor_crm VARCHAR(10),
      FOREIGN KEY (patient_cpf) REFERENCES patients(patient_cpf),
      FOREIGN KEY (doctor_crm) REFERENCES doctors(doctor_crm))')

  conn.exec('CREATE TABLE exams (
      exam_id SERIAL PRIMARY KEY,
      exam_type VARCHAR NOT NULL,
      exam_limits VARCHAR(10) NOT NULL,
      exam_result int NOT NULL,
      token_result VARCHAR(6) NOT NULL,
      FOREIGN KEY (token_result) REFERENCES results(token_result))')
end
