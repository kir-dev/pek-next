// TODO make sure if principles are correctly ordered
window.addEventListener("load", main)

function main() {
    const container = document.getElementById("evaluation-table")
    fetch('table-data.json')
        .then(data => data.json())
        .then(data => EvaluationTable(container, data))
}

const EvaluationTable = (container, tableData) => {
    const principles = {
        responsibility: tableData.principles["RESPONSIBILITY"],
        work: tableData.principles["WORK"]
    }
    const users = tableData.users

    intTable()

    function intTable() {
        tableHeight = window.innerHeight * 0.8;
        rowHeight = tableHeight / 15
        const hot = new Handsontable(container, {
            data: userData(),
            rowHeaders: true,
            colHeaders: true,
            nestedHeaders: nestedHeaders(),
            width: '100%',
            colWidths: 100,
            height: tableHeight * 0.7,
            rowHeights: rowHeight,
            autoRowSize: {syncLimit: 300},
            fixedColumnsLeft: 1,
            fixedRowsBottom: 1
        });
    }

    function nestedHeaders() {
        return [[
            {label: '', colspan: 1},
            {label: 'Felelősség pont', colspan: principles.responsibility.length},
            {label: 'Munka pont', colspan: principles.work.length},
            {label: 'Szumma', colspan: 2}
        ], [
            'Körtag neve', ...principles.responsibility.map(p => p.name), ...principles.work.map(p => p.name), "a", "b"
        ]]
    }

    function userData() {
        return users.map(user => {
            return [user.name, ...user.pointDetails.RESPONSIBILITY.map(pd => pd.point), ...user.pointDetails.WORK.map(pd => pd.point)]
    })
    }

    function appendSumColumns(rows){
        return rows.map(row)
    }
    return {}
}
