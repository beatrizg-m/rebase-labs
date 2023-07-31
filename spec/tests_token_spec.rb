require 'spec_helper'
require_relative '../app/exams_importer'

describe 'acessa a rota passando um token' do
  it 'e vê dados do test' do
    conn = ExamsImporter.start_connection

    conn.exec("INSERT INTO patients (patient_cpf, patient_name, patient_email, patient_birthdate, patient_address,
              patient_city, patient_state) VALUES ('12345678900', 'João', 'joao@yahoo.com', '1999-01-01', 'Rua Lua',
              'Recife', 'PE')")
    conn.exec("INSERT INTO doctors (doctor_crm, doctor_crm_state, doctor_name, doctor_email) VALUES ('123456',
              'SP', 'João', '123')")
    conn.exec("INSERT INTO results (patient_cpf, doctor_crm, token_result, exam_date) VALUES (12345678900, 123456,
              'AS8752', '1990-01-01')")
    conn.exec("INSERT INTO exams (exam_id, exam_type, exam_limits, exam_result, token_result) VALUES (1, 'Tipo 1',
              'Limites 1', 40, 'AS8752')")

    visit '/tests/AS8752'

    expect(page.status_code).to eq(200)
    expect(page).to have_content('result_token')
    expect(page).to have_content('AS8752')
    expect(page).to have_content('name')
    expect(page).to have_content('doctor')
    expect(page).to have_content('123456')
    expect(page).to have_content('result')
    expect(page).to have_content('45')

  end
end
