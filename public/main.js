const url = 'http://localhost:3000/tests';
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
      detailsData.textContent = `Nome: ${patient.name}\nCPF: ${patient.cpf}\nE-mail: ${patient.email}\nMédico: ${patient.doctor.name}`;
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

