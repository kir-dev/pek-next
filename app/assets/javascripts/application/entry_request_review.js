const entryRequestReviewUpdateSubjects = {}

async function submitEntryRequestReview(id) {
    console.log(id + " " + event);
    const statusIndicator = document.getElementById(`entry-request-${id}-status-indicator`)
    statusIndicator.className = "uk-icon-cog uk-float-right"
    if(!entryRequestReviewUpdateSubjects[id]){
        const { Subject, debounceTime } = rxjs;
        const subject = new Subject();
        const result = subject.pipe(debounceTime(1000))
        result.subscribe({
            next: async () => await updateEntryRequestReview(id),
            // next: () => { console.log(Math.random())}
        });
        entryRequestReviewUpdateSubjects[id] = result
    }
    const subject = entryRequestReviewUpdateSubjects[id]
    subject.next()
}

async function updateEntryRequestReview(id){
    const entryType = document.getElementById(`entry-request-${id}-entry-type`).value
    const finalized = document.getElementById(`entry-request-${id}-finalized`).checked
    const justification = document.getElementById(`entry-request-${id}-justification`).value
    console.log(entryType + finalized + justification)
    const statusIndicator = document.getElementById(`entry-request-${id}-status-indicator`)
    try {
        const response = await fetch(`/entry_requests/${id}/update_review`, {
            method: 'put',
            body: JSON.stringify({
                "entry_type": entryType,
                "finalized": finalized,
                "justification": justification,
            }),
            headers: {
                'X-CSRF-TOKEN': getCsrfToken(),
                'Content-Type': 'application/json'
            }
        })
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        statusIndicator.className = "uk-icon-check uk-float-right"
    }
    catch(error) {
        statusIndicator.className = "uk-icon-close uk-float-right"

    }
}