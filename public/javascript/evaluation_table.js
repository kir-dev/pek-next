window.addEventListener("load",main)
function main() {
    fetch('table-columns.json')
        .then(data=>data.json())
        .then(
            cols => fetch('table-data.jon')
                .then(data=> data.json())
                .then(data=> intTable(cols,data))
        )
}

function intTable(cols,data){
    tableHeight = window.innerHeight*0.8;
    rowHeight = tableHeight/15
    var container = document.getElementById("evaluation-table")
var hot = new Handsontable(container, {
    data: data,
    rowHeaders: true,
    colHeaders: cols.map(c=>c['title']),
    width: '100%',
    colWidths:100 ,
    height: tableHeight*0.7,
    rowHeights: rowHeight,
    autoRowSize: {syncLimit: 300},
    fixedColumnsLeft:2,
    fixedRowsBottom: 1
});
}
// key order is arbitrary in json, but array order is relyable
// use arrays instead of hashes
// create tests for checking the correct values