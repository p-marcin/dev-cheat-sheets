docsearch({
    appId: 'XDWJOL3OGD',
    apiKey: '8bd63b957b8bbb05e02a8744c4bb280c',
    indexName: 'crawler_DEV_CHEAT_SHEETS',
    inputSelector: '#search-input',
    autocompleteOptions: {
        hint: false,
        minLength: 4
    },
    algoliaOptions: {
        advancedSyntax: true,
        hitsPerPage: 8
    }
});
