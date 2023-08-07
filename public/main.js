const url = 'http://localhost:3000/tests';
const importUrl = 'http://localhost:3000/import';
const searchButton = document.querySelector('#submit-search')
const clearButton = document.querySelector('#clear-filter')
let initialState = []

function buildTable(data){
  const dataList = document.getElementById('dataList');

  data.forEach((patient) => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <th class="data" >${patient.result_token}</th>
      <th class="data" >${patient.name}</th>
      <th class="data" >${patient.cpf}</th>
      <th class="data" >${patient.email}</th>
      <th class="data" >${patient.doctor.name}</th>
      <td>
        <a href="#detailsModal" class="details-link" data-bs-toggle="modal">
          Detalhes
        </a>
      </td>
    `;
    dataList.appendChild(tr);

    const detailsButton = tr.querySelector('.details-link');
    detailsButton.addEventListener('click', () => {
      const detailsData = document.getElementById('detailsData');
      detailsData.innerHTML = `
        <h6>Paciente</h6>
        <li><strong>Nome:</strong> ${patient.name}</li>
        <li><strong>CPF:</strong> ${patient.cpf}</li>
        <li><strong>E-mail:</strong> ${patient.email}</li>
        <h6>Médico</h6>
        <li><strong>Nome:</strong> ${patient.doctor.name}</li>
        <li><strong>CRM:</strong> ${patient.doctor.crm}</li>
        <li><strong>CRM Estado:</strong> ${patient.doctor.crm_state}</li>
        <h5>Exames</h5>
      `;
      const dataExam = document.getElementById('dataExam');
      const tr = document.getElementById('tr');

      tr.innerHTML = `
        <th class="data" >${patient.result_token}</th>
        <th class="data" >${patient.type}</th>
        <th class="data" >${patient.limits}</th>
        <th class="data" >${patient.result}</th>
      `;
      dataExam.appendChild(tr);
    });
  });
}

fetch(url)
  .then((response) => response.json())
  .then((data) => {
    initialState = data
    buildTable(data)
  })
  .catch(function (error) {
    console.log(error);
  });

searchButton.addEventListener('click', filterData)
clearButton.addEventListener('click', (e) => handleClearButtonClick(e, initialState))

function handleClearButtonClick(event, data) {
  event.preventDefault()
  const filterElement = document.querySelector('#filter');
  filterElement.value = "";
  const tableDataRows = document.querySelectorAll('tbody tr')
  tableDataRows.forEach(row => row.remove())
  buildTable(data)
}

function filterData(event) {
  event.preventDefault()
  const filterElement = document.querySelector('#filter');
  const patientRows = document.querySelectorAll('tbody tr');

  const filterText = filterElement.value.toLowerCase().trim();

  patientRows.forEach(row => {
    const cells = Array.from(row.children)

    if (!cells.some(cell => cell.textContent.toLocaleLowerCase().includes(filterText))){
      row.remove()
    }
  })
}

function importFile(event, file) {
  const importDoc = document.getElementById('formFile');

}

