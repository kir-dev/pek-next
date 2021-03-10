window.addEventListener("load", main)

function main() {
    fetch('table-data.json')
        .then(data => data.json())
        .then(data => EvaluationTable("evaluation_table", data))
}

function EvaluationTable(containerElementId, _input) {
    const container = document.getElementById(containerElementId)
    const input = _input
    const that = this
    const principles = input.principles
    const users = input.users
    const nestedColumns = parseColumns(principles)
    intTable(nestedColumns, null)
}

/*
 nestedHeaders: [
      [{label:''},{label: 'munka', colspan: 4},{label: 'munka', colspan: 4},{label: 'szumma', colspan:2}],
      ['1','2','3','4','5','6','1','2','3','4','5']

    ]
* */
function parseColumns(principles) {
    const workPrinciples = selectPrinciples(principles, "WORK")
    const responsiblilityPrinciples = selectPrinciples(principles, "RESPONSIBILITY")
    const workPrincipleCount = workPrinciples.length
    const responsiblilityPrincipleCount = responsiblilityPrinciples.length

    const nestedColumns = [[
        {label: '',colspan: 1},
        {label: 'Felelősség pont', colspan: responsiblilityPrincipleCount},
        {label: 'Munka pont', colspan: workPrincipleCount},
        {label: 'Szumma', colspan: 2}
    ], [
        'Körtag neve', ...responsiblilityPrinciples.map(p=>p.name), ...workPrinciples.map(p=>p.name),"a","b"
    ]]
    return nestedColumns
}

function selectPrinciples(principles, type) {
    return principles.filter(principle => principle.type == type)
}

function intTable(columns,data) {
    tableHeight = window.innerHeight * 0.8;
    rowHeight = tableHeight / 15
    const container = document.getElementById("evaluation-table")
    const hot = new Handsontable(container, {
        data:  Handsontable.helper.createSpreadsheetData(500,15),
        rowHeaders: true,
        colHeaders: true,
        nestedHeaders: columns,
        width: '100%',
        colWidths: 100,
        height: tableHeight * 0.7,
        rowHeights: rowHeight,
        autoRowSize: {syncLimit: 300},
        fixedColumnsLeft: 1,
        fixedRowsBottom: 1
    });
}

// key order is arbitrary in json, but array order is relyable
// use arrays instead of hashes
// create tests for checking the correct values