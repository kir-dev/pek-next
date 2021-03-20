// TODO make sure if principles are correctly ordered
window.addEventListener("load", main)

function main() {
    const container = document.getElementById("evaluation-table")
    fetch('table-data.json')
        .then(data => data.json())
        .then(data => EvaluationTable(container, data))
}

const EvaluationTable = (container, rawData) => {
    const principles = {
        responsibility: rawData.principles["RESPONSIBILITY"],
        work: rawData.principles["WORK"],
        all: [...rawData.principles["RESPONSIBILITY"], ...rawData.principles["WORK"]]
    }
    const columnIndexes = generateColumnIndexes()
    const users = rawData.users
    const rowIndexes = generateRowIndexes()
    let tableData = appendRowsForAverage(userData())
    columnIndexes.points.forEach(column => setColumnStatistics(tableData, column))

    const table = intTable()
    table.addHook('afterChange', cellChangeHandler)

    function intTable() {
        tableHeight = window.innerHeight * 0.8;
        rowHeight = tableHeight / 15
        const hot = new Handsontable(container, {
            data: tableData,
            rowHeaders: true,
            colHeaders: true,
            nestedHeaders: nestedHeaders(),
            width: '100%',
            colWidths: 10,
            // headerTooltips:true,
            height: tableHeight,
            rowHeights: rowHeight,
            autoRowSize: {syncLimit: 300},
            fixedColumnsLeft: 1,
            fixedRowsBottom: 3,
        });
        return hot;
    }

    function generateColumnIndexes() {
        let responsibilityIndexes = []
        for (let i = 1; i < principles.responsibility.length + 1; i++) {
            responsibilityIndexes.push(i)
        }
        let lastPrincipleIndex = principles.responsibility.length + principles.work.length
        let workIndexes = []
        for (let i = principles.responsibility.length + 1; i < lastPrincipleIndex + 1; i++) {
            workIndexes.push(i)
        }
        let points = [...Array(lastPrincipleIndex + 3 + 1).keys()]
        points.splice(0, 1)

        const sumResponsibility = lastPrincipleIndex + 1;
        const sumWork = lastPrincipleIndex + 2;
        const sumAll = lastPrincipleIndex + 3;
        return {
            name: 0,
            responsibility: responsibilityIndexes,
            work: workIndexes,
            principles: [...responsibilityIndexes, ...workIndexes],
            points: points,
            sumResponsibility: sumResponsibility,
            sumWork: sumWork,
            sumAll: sumAll,
            statistics: [sumWork, sumResponsibility, sumAll]
        }
    }

    function generateRowIndexes() {
        return {
            user: [...new Array(users.length).keys()],
            average: users.length,
            averageWithoutEmpty: users.length + 1,
            sum: users.length + 2
        }
    }

    function cellChangeHandler(changesArray, source) {
        if (!changesArray) {
            return
        }
        let changes = changesArray.map(changeArray => changeArrayToHash(changeArray))
        const pointChanges = changes.filter(changes => columnIndexes.principles.includes(changes.column))
        const changedRows = [...new Set(pointChanges.map(change => change.row))]
        const changedColumns = [...new Set(pointChanges.map(change => change.column))]
        let newTableData = table.getData();
        changedRows.forEach(row => {
            if (row < users.length) {
                setRowStatistics(newTableData, row);
            }
        })

        changedColumns.forEach(column => {
            setColumnStatistics(newTableData, column)
        })
        columnIndexes.statistics.forEach(column => {
            setColumnStatistics(newTableData, column)
        })
        table.loadData(newTableData);
    }

    function setRowStatistics(newTableData, rowIndex) {
        const sumResponsibility = sumRowColumns(newTableData[rowIndex], columnIndexes.responsibility)
        const sumWork = sumRowColumns(newTableData[rowIndex], columnIndexes.work)
        newTableData[rowIndex][columnIndexes.sumResponsibility] = sumResponsibility
        newTableData[rowIndex][columnIndexes.sumWork] = sumWork
        newTableData[rowIndex][columnIndexes.sumAll] = sumResponsibility + sumWork
    }

    function setColumnStatistics(newTableData, column) {
        const userValues = newTableData.slice(0, users.length).map(values => +values[column]) // COSTLY
        const colSum = userValues.reduce((sum, num) => sum = sum + num, 0)
        let average = colSum / users.length;
        const nonEmptyCount = userValues.filter((point) => point > 0).length
        let averageWithoutEmpty = colSum / nonEmptyCount
        newTableData[rowIndexes.average][column] = formatNumber(average);
        newTableData[rowIndexes.averageWithoutEmpty][column] = formatNumber(averageWithoutEmpty);
        newTableData[rowIndexes.sum][column] = formatNumber(colSum);
    }

    function formatNumber(number) {
        let formatted = Number(number)
        if (formatted) {
            formatted = Math.round(number * 100) / 100
        } else {
            formatted = 0
        }
        return formatted;
    }

    function changeArrayToHash(changeArray) {
        return {
            row: changeArray[0],
            column: changeArray[1],
            prevValue: changeArray[2],
            newValue: changeArray[3]
        }
    }

    function sumRowColumns(row, columns) {
        const numArray = columns.map(column => +row[column])
        return numArray.reduce((sum, num) => sum + num, 0)
    }

    function nestedHeaders() {
        return [[
            {label: '', colspan: 1},
            {label: 'Felelősség pont', colspan: principles.responsibility.length},
            {label: 'Munka pont', colspan: principles.work.length},
            {label: 'Szumma', colspan: 3}
        ], [
            'Körtag neve',
            ...principles.all.map(principle => principle.name),
            "Felelősség", "Munka", "Összes"
        ]]
    }

    function userData() {
        return users.map(user => {
            let sumResponsibility = user.pointDetails.RESPONSIBILITY.reduce((sum, pd) => sum = sum + pd.point, 0)
            let sumWork = user.pointDetails.WORK.reduce((sum, pd) => sum = sum + pd.point, 0)

            return [user.name,
                ...user.pointDetails.RESPONSIBILITY.map(pd => pd.point),
                ...user.pointDetails.WORK.map(pd => pd.point),
                sumResponsibility, sumWork, sumResponsibility + sumWork
            ]
        })
    }

    function appendRowsForAverage(rows) {
        let averageRow = new Array(1 + principles.all.length + 3)
        averageRow[0] = 'Átlag'
        rows.push([...averageRow])
        averageRow[0] = 'Átlag (0 pont nélkül)'
        rows.push([...averageRow])
        averageRow[0] = 'Szumma'
        rows.push([...averageRow])

        return rows
    }

    return {}
}
