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
    const users = rawData.users
    const tableData = appendRowsForAverage(userData())
    const table = intTable()
    table.addHook("afterChange", cellChangeHandler)
    sumRow(2)

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
            afterChange: (changes) => cellChangeHandler(changes),
            columnSummary: [
                ...[...Array(principles.all.length + 2)
                    .keys()].map(index => columnCalculation(index + 1, 1, averageCalculation)),
                ...[...Array(principles.all.length + 2)
                    .keys()].map(index => columnCalculation(index + 1, 0, averageWithoutEmptyCalculation))]
        });
        return hot;
    }

    function cellChangeHandler(changesArray) {
        let changes = changesArray.map(changeArray => changeArrayToHash(changeArray))
        changes.forEach(change => {
            if (change.row > users.length || change.column > principles.all.length - 1) {
                table.setCellData(change.row, principles.all.length+2, sumRow(change.row))

            }
        })
    }

    function changeArrayToHash(changeArray) {
        return {
            row: changeArray[0],
            column: changeArray[1],
            prevValue: changeArray[2],
            newValue: changeArray[3]
        }
    }

    function sumRow(rowIndex) {
        const length = principles.responsibility.length + principles.work.length
        let rowPointSum = 0;
        for (let i = 1; i < length + 1; i++) {
            rowPointSum += table.getDataAtCell(rowIndex, i)
        }

        return rowPointSum;
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
            "Felelősség", "Munka","Összes"
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
