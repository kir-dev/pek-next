window.addEventListener("load",main)
function main() {
    fetch('table-data.json')
        .then(data=>data.json())
        .then(data => intTable(data))
}

function intTable(data){
    tableHeight = window.innerHeight*0.8;
    rowHeight = tableHeight/15
    var container = document.getElementById("evaluation-table")
var hot = new Handsontable(container, {
    data: data,
    rowHeaders: true,
    colHeaders: true,
    width: '100%',
    colWidths:100 ,
    height: tableHeight,
    rowHeights: rowHeight,
    autoRowSize: {syncLimit: 300},
    fixedColumnsLeft:2,
    fixedRowsBottom: 1
});
}
