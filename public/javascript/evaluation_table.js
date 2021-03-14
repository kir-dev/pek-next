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
            data: appendRowsForAverage(userData()),
            rowHeaders: true,
            colHeaders: true,
            nestedHeaders: nestedHeaders(),
            width: '100%',
            colWidths: 100,
            height: tableHeight * 0.7,
            rowHeights: rowHeight,
            autoRowSize: { syncLimit: 300 },
            fixedColumnsLeft: 1,
            fixedRowsBottom: 2,

        });
    }

    function nestedHeaders() {
        return [[
            {label: '', colspan: 1},
            {label: 'Felelősség pont', colspan: principles.responsibility.length},
            {label: 'Munka pont', colspan: principles.work.length},
            {label: 'Szumma', colspan: 2}
        ], [
            'Körtag neve',
            ...principles.responsibility.map(p => p.name),
            ...principles.work.map(p => p.name),
            "Felelősség", "Munka"
        ]]
    }

    function userData() {
        return users.map(user => {
            return [user.name,
                ...user.pointDetails.RESPONSIBILITY.map(pd => pd.point),
                ...user.pointDetails.WORK.map(pd => pd.point),
                1,1
            ]
    })
    }

    function appendRowsForAverage(rows){
        averageRow = new Array(1 + principles.responsibility.length + principles.work.length + 2)
        averageRow[0]='Átlag'
        rows.push([...averageRow])
        averageRow[0]='Átlag (0 pont nélkül)'
        rows.push([...averageRow])
        return rows
    }
    return {}
}
