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
        work: rawData.principles["WORK"]
    }
    const users = rawData.users
    const tableData = appendRowsForAverage(userData())
    intTable()

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
            fixedRowsBottom: 2,
            columnSummary: [
                ...[...Array(principles.responsibility.length + principles.work.length)
                    .keys()].map(index => columnCalculation(index + 1, 1, averageCalculation))
            ]
        });
    }

    function averageCalculation(endpoint) {
        var rangeSums = 0;
        var hotInstance = this.hot;

        // go through all declared ranges
        for (var r in endpoint.ranges) {
            if (endpoint.ranges.hasOwnProperty(r)) {
                rangeSums += sumRange(endpoint.ranges[r], hotInstance, endpoint);
            }
        }
        let rangeLength = calculateRangeLength(endpoint.ranges)

        return rangeSums / rangeLength;
    }

    function calculateRangeLength(ranges) {
        return ranges.map(v => v[1] - v[0]).reduce((sum, num) => sum += num)
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

    function columnCalculation(column, destinationRow, calculation) {
        return {
            ranges: [
                [0, tableData.length - 2]
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
                1, 1
            ]
        })
    }

    function appendRowsForAverage(rows) {
        averageRow = new Array(1 + principles.responsibility.length + principles.work.length + 2)
        averageRow[0] = 'Átlag'
        rows.push([...averageRow])
        averageRow[0] = 'Átlag (0 pont nélkül)'
        rows.push([...averageRow])
        return rows
    }

    return {}
}
