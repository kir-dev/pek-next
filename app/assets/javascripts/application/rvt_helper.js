function rvtHelperListItemId(userId){
    return `rvt-helper-user-${userId}`
}

function rvtHelperButtonId(userId){
    return `rvt-helper-suggest-button-user-${userId}`
}

function removeElementById(id){
    const element = document.getElementById(id)
    if(element){
        element.remove()
    }
}

function getCsrfToken() {
    return document.getElementsByName("csrf-token")[0].content
}

function addRvtHelper(userId) {
    const url = `/admin/rvt_helpers/${userId}/add`
    fetch(url, {
        method: 'post',
        headers: {'X-CSRF-Token': getCsrfToken()},
    }).then(function (result) {
        removeElementById(rvtHelperButtonId(userId))
    }).catch(function (err) {
        console.warn('Something went wrong.', err)
    });
}

function removeRvtHelper(userId) {
    const url = `/admin/rvt_helpers/${userId}/remove`
    fetch(url, {
        method: 'post',
        headers: {'X-CSRF-Token': getCsrfToken()},
    }).then(function (result) {
        removeElementById(rvtHelperListItemId(userId))
        removeElementById(rvtHelperButtonId(userId))
    }).catch(function (err) {
        console.warn('Something went wrong.', err)
    })
}
