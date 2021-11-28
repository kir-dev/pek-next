function removePost(group_id, membership_id, post_type_id, post_id) {
    const button = document.getElementById(`remove-${membership_id}-${post_type_id}`)
    button.disabled = true
    fetch(`/groups/${group_id}/memberships/${membership_id}/posts/${post_id}.json`,
        {
            headers: {
                'X-CSRF-TOKEN': getCsrfToken(),
                // 'Content-Type': 'application/json'
            },
            method: 'DELETE',
            credentials: 'same-origin',
        })
        .then(response => {
            if (response.status === 200) {
                button.onclick = () => addPost(group_id, membership_id, post_type_id)
                button.id = `add-${membership_id}-${post_type_id}`

                button.classList.remove("uk-button-danger")
                button.classList.add("uk-button-success")

                const buttonTexts = button.innerText.split('(')
                buttonTexts[1] = "(Hozzáad)"
                button.innerText = buttonTexts.join('')
                button.disabled = false
            }
        })
}

function addPost(group_id, membership_id, post_type_id) {
    const button = document.getElementById(`add-${membership_id}-${post_type_id}`)
    button.disabled = true
    fetch(`/groups/${group_id}/memberships/${membership_id}/posts.json`, {
        headers: {
            'X-CSRF-TOKEN': getCsrfToken(),
            'Content-Type': 'application/json'
        },
        method: 'POST',
        credentials: 'same-origin',
        body: JSON.stringify({post_type_id: post_type_id})
    }).then(response => {
        if (response.status === 200) {
            response.json().then(data => {
                button.onclick = () => removePost(group_id, membership_id, post_type_id, data.post_id)
                button.id = `remove-${membership_id}-${post_type_id}`

                button.classList.remove("uk-button-success")
                button.classList.add("uk-button-danger")

                const buttonTexts = button.innerText.split('(')
                buttonTexts[1] = "(Elvesz)"
                button.innerText = buttonTexts.join('')

                button.disabled = false
            });
        }
    })
}
