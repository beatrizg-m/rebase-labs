require 'spec_helper'
require_relative '../app/exams_importer'
describe 'acessa /tests' do
  it 'e retorna uma lista de testes' do
    conn = ExamsImporter.start_connection

    conn.exec("INSERT INTO patients (patient_cpf, patient_name, patient_email, patient_birthdate, patient_address,
              patient_city, patient_state)
              VALUES ('12345678909', 'Ladislau Duarte', 'lisha@rosenbaum.org', '1981-02-02', 'rua amarela', 'olinda', 'PE')")
    result = conn.exec('SELECT * FROM patients WHERE patient_cpf = $1', ['12345678909'])

    visit '/tests'

    expect(page.status_code).to eq(200)
    expect(result.count).to eq(1)
    expect(result[0]['patient_cpf']).to eq '12345678909'
  end

  it 'e não tem nada cadastrado' do
    conn = ExamsImporter.start_connection

    result = conn.exec('SELECT * FROM patients WHERE patient_cpf = $1', ['09920455253'])

    visit '/tests'

    expect(page.status_code).to eq(200)
    expect(result.count).not_to eq(1)
    expect(page).not_to have_content('Ladislau Duarte')
  end
end
