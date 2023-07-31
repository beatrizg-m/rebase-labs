require 'spec_helper'
require_relative '../app/exams_importer'

describe 'Importa arquivo csv atraves do script' do
  it 'e visualiza todos os testes' do
    conn = ExamsImporter.import_from_csv('./data.csv')

    visit '/exams'

    expect(page.status_code).to eq(200)
    expect(page).to have_content('Token')
    expect(page).to have_content('Nome')
    expect(page).to have_content('CPF')
    expect(page).to have_content('Email')
    expect(page).to have_content('Médico')
    expect(page).to have_content('Detalhes')

    # res = conn.exec('SELECT count(*) FROM exams')
    # expect(res[0]['count'].to_i).to eq(300)
  end
end

