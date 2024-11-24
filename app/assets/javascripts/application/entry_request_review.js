const entryRequestReviewUpdateSubjects = {}

async function submitEntryRequestReview(id) {
    console.log(id + " " + event);
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
    const finalized = document.getElementById(`entry-request-${id}-finalized`).value
    const justification = document.getElementById(`entry-request-${id}-justification`).value
    console.log(entryType + finalized + justification)
    try {
        await fetch(`/entry_requests/${id}/update_review`, {
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
    }
    catch(error) {
    }
}