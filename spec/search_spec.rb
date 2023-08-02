require 'spec_helper'

describe 'Visualiza todos os exames cadastrados' do
  it 'mas quer buscar apenas pelos de Mariana' do
    conn = ExamsImporter.start_connection

    conn.exec("INSERT INTO patients (patient_cpf, patient_name, patient_email,    patient_birthdate, patient_address,
              patient_city, patient_state) VALUES ('12345678900', 'João', 'joao@yahoo.com', '1999-01-01', 'Rua Lua',
              'Recife', 'PE')")
    conn.exec("INSERT INTO doctors (doctor_crm, doctor_crm_state, doctor_name, doctor_email) VALUES ('123456',
              'SP', 'João', '123')")
    conn.exec("INSERT INTO results (patient_cpf, doctor_crm, token_result, exam_date) VALUES (12345678900, 123456,
              'AS8752', '1990-01-01')")
    conn.exec("INSERT INTO exams (exam_id, exam_type, exam_limits, exam_result, token_result) VALUES (1, 'Tipo 1',
              'Limites 1', 40, 'AS8752')")

    conn.exec("INSERT INTO patients (patient_cpf, patient_name, patient_email,    patient_birthdate, patient_address,
              patient_city, patient_state) VALUES ('12345123450', 'Mariana', 'mari.mariana@yahoo.com', '1995-01-01', 'Rua Sol',
              'Recife', 'PE')")
    conn.exec("INSERT INTO doctors (doctor_crm, doctor_crm_state, doctor_name, doctor_email) VALUES ('321456',
              'PE', 'Vivian', 'vivi@yahoo.com')")
    conn.exec("INSERT INTO results (patient_cpf, doctor_crm, token_result, exam_date) VALUES (12345123450, 321456,
              '5SMO75', '1990-01-01')")
    conn.exec("INSERT INTO exams (exam_id, exam_type, exam_limits, exam_result, token_result) VALUES (2, 'Tipo 2',
              'Limites 2', 45, '5SMO75')")

    visit '/exams'
    # fill_in 'Search for data', with: 'Mariana'
    # click_on 'Search'

    expect(page).to have_content('Mariana')
    expect(page).not_to have_content('João')
  end
end
