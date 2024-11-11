const entryRequestReview = (function() {
    const module = {};

    module.init = function() {
        console.log('review init')
        const justifications = document.querySelectorAll("[data-type='entry-request-justification']");

        console.log(justifications)
        for (let justification of justifications) {
            justification.addEventListener("input", handleChange)
        }
    }
    async function handleChange(event)
    {
        console.log('event ' + event.target.value )
        await fetch( '/entry_requests/272883/update_review', {method: 'put',
            headers: {
                'X-CSRF-TOKEN': getCsrfToken(),
                'Content-Type': 'application/json'
            }})
    }

    return module;
}());

$(document).ready(entryRequestReview.init);

