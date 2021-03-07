window.addEventListener('load',setup)

function setup(){

    getColums()
    function initTable(columns){


    const url=document.getElementById("evaluation-table-url").innerText
    var table = new Tabulator("#example-table",{
        ajaxURL:"table-data.json",
        autoColumns:true,
        autoColumnsDefinitions:columns
    });
    console.log("init table")
    }

    function getColums(){
        fetch('table-columns.json')
            .then(res => res.json())
            .then(data => initTable(data))
    }
}