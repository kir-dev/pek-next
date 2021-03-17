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
    const tableData = appendRowsForAverage(userData())
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
            colWidths: 100,
            height: tableHeight * 0.7,
            rowHeights: rowHeight,
            autoRowSize: {syncLimit: 300},
            fixedColumnsLeft: 1,
            fixedRowsBottom: 3,
            // afterChange: (changes, source) => cellChangeHandler(changes, source),
            columnSummary: [
                ...[...Array(principles.all.length + 2)
                    .keys()].map(index => columnCalculation(index + 1, 1, averageCalculation)),
                ...[...Array(principles.all.length + 2)
                    .keys()].map(index => columnCalculation(index + 1, 0, averageWithoutEmptyCalculation))]
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
        return {
            name: 0,
            responsibility: responsibilityIndexes,
            work: workIndexes,
            principles: [...responsibilityIndexes, ...workIndexes],
            sumResponsibility: lastPrincipleIndex + 1,
            sumWork: lastPrincipleIndex + 2,
            sumAll: lastPrincipleIndex + 3
        }

    }

    function cellChangeHandler(changesArray, source) {

        if (!changesArray || source =="loadData") {
            return
        }
        let changes = changesArray.map(changeArray => changeArrayToHash(changeArray))
        if (!changes) {
            return
        }
        const pointChanges = changes.filter(changes => columnIndexes.principles.includes(changes.column))
        const changedRows = [... new Set(pointChanges.map(change => change.row))]
        let newTableData = table.getData();
        changedRows.forEach(row => {
            if (row < users.length) {
                // table.setDataAtCell(row, columnIndexes.sumResponsibility, sumRowColumns(row, columnIndexes.responsibility))
                // table.setDataAtCell(row, columnIndexes.sumWork, sumRowColumns(row, columnIndexes.work))
                // table.setDataAtCell(row, columnIndexes.sumAll, sumRowColumns(row, [columnIndexes.sumResponsibility, columnIndexes.sumWork]))
                const sumResponsibility =sumRowColumns(row, columnIndexes.responsibility)
                newTableData[row][columnIndexes.sumResponsibility]=sumResponsibility
                const sumWork = sumRowColumns(row, columnIndexes.work)
                newTableData[row][columnIndexes.sumWork]=sumWork
                newTableData[row][columnIndexes.sumAll]= sumResponsibility + sumWork
            }
        })
        table.loadData(newTableData);
    }

    function changeArrayToHash(changeArray) {
        return {
            row: changeArray[0],
            column: changeArray[1],
            prevValue: changeArray[2],
            newValue: changeArray[3]
        }
    }

    function sumRowColumns(rowIndex, columns) {
        const numArray=columns.map(c=> +table.getDataAtCell(rowIndex,c))
        return numArray.reduce((sum,num) => sum+num,0)
    }

    function sumRowValues(rowIndex, length) {
        let rowSum = 0;
        for (let i = 1; i < length; i++) {
            let rowValue = hot
        }
    }

    function averageCalculation(endpoint) {
        let rangeSums = 0;
        let hotInstance = this.hot;

        // go through all declared ranges
        for (let r in endpoint.ranges) {
            if (endpoint.ranges.hasOwnProperty(r)) {
                rangeSums += sumRange(endpoint.ranges[r], hotInstance, endpoint);
            }
        }
        let rangeLength = calculateRangeLength(endpoint.ranges)

        return rangeSums / rangeLength;
    }

    function averageWithoutEmptyCalculation(endpoint) {
        let rangeSums = 0;
        let rangeNonEmptyCount = 0;
        let hotInstance = this.hot;

        // go through all declared ranges
        for (var r in endpoint.ranges) {
            if (endpoint.ranges.hasOwnProperty(r)) {
                rangeSums += sumRange(endpoint.ranges[r], hotInstance, endpoint);
                rangeNonEmptyCount += countNonEmptyColumns(endpoint.ranges[r], hotInstance, endpoint)
            }
        }
        let result = rangeSums / rangeNonEmptyCount;
        if (result) {
            return result;
        } else {
            return 0;
        }
    }

    function calculateRangeLength(ranges) {
        return ranges.map(v => v[1] - v[0]).reduce((sum, num) => sum += num) + 1
    }

    function sumRange(rowRange, hotInstance, endpoint) {
        let i = rowRange[1] || rowRange[0];
        let sum = 0;

        do {
            let cellNumber = parseInt(hotInstance.getDataAtCell(i, endpoint.sourceColumn), 10);
            if (!cellNumber) {
                cellNumber = 0;
            }
            sum += cellNumber

            i--;
        } while (i >= rowRange[0]);
        return sum;
    }

    function countNonEmptyColumns(rowRange, hotInstance, endpoint) {
        let i = rowRange[1] || rowRange[0];
        let count = 0;
        do {
            let cellNumber = parseInt(hotInstance.getDataAtCell(i, endpoint.sourceColumn), 10);
            if (cellNumber) {
                count++;
            }

            i--;
        } while (i >= rowRange[0]);
        return count;
    }

    function columnCalculation(column, destinationRow, calculation) {
        return {
            ranges: [
                [0, tableData.length - 1 - 2]
            ],
            destinationRow: destinationRow,
            destinationColumn: column,
            reversedRowCoords: true,
            type: 'custom',
            customFunction: calculation,
            forceNumeric: true,
            roundFloat: 2
        }
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
            return [user.name,
                ...user.pointDetails.RESPONSIBILITY.map(pd => pd.point),
                ...user.pointDetails.WORK.map(pd => pd.point),
                1, 1, 1
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
