const entryRequestReviewUpdateSubjects = {}

async function submitEntryRequestReview(id) {
    const statusIndicator = document.getElementById(`entry-request-${id}-status-indicator`)
    statusIndicator.className = "uk-icon-keyboard-o uk-float-right"
    if (!entryRequestReviewUpdateSubjects[id]) {
        const {Subject, debounceTime} = rxjs;
        const subject = new Subject();
        const result = subject.pipe(debounceTime(1000))
        result.subscribe({
            next: async () => await updateEntryRequestReview(id),
        });
        entryRequestReviewUpdateSubjects[id] = result
    }
    const subject = entryRequestReviewUpdateSubjects[id]
    subject.next()
}

async function updateEntryRequestReview(id) {
    const statusIndicator = document.getElementById(`entry-request-${id}-status-indicator`)
    statusIndicator.className = "uk-icon-cog uk-icon-spin uk-float-right"
    const entryType = document.getElementById(`entry-request-${id}-entry-type`).value
    const finalized = document.getElementById(`entry-request-${id}-finalized`).checked
    const justification = document.getElementById(`entry-request-${id}-justification`).value
    const recommendationElements = Array.from(document.getElementsByClassName(`entry-request-${id}-recommendation`))
    const recommendations = recommendationElements.map((element) => {
        return {"resort_id": element.getAttribute("data-resort-id"), "value": element.value}
    })
    try {
        const response = await fetch(`/entry_requests/${id}/update_review`, {
            method: 'put',
            body: JSON.stringify({
                "entry_request": {
                    "entry_type": entryType,
                    "finalized": finalized,
                    "justification": justification,
                },
                "recommendations": recommendations
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
    } catch (error) {
        statusIndicator.className = "uk-icon-close uk-float-right"

    }
}
