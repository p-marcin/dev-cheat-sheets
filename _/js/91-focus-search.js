window.addEventListener('load', function focusSearchInput () {
    window.removeEventListener('load', focusSearchInput)
    document.querySelector('#search-input').focus()
})
