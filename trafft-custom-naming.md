For custom nav naming on Trafft use JS code:

```js
function changeServicesMenuText(newText) {
    let elements = document.querySelectorAll('a, span, div, h1, h2, h3, h4, h5, h6, p');

    for (let i = 0; i < elements.length; i++) {
        let element = elements[i];

        // Iterate through child nodes to find text nodes
        for (let j = 0; j < element.childNodes.length; j++) {
            let node = element.childNodes[j];

            // Check if it's a text node and contains "Services"
            if (node.nodeType === Node.TEXT_NODE && node.textContent.trim() === 'Services') {
                node.textContent = newText;
                return; // Exit after the first successful change
            }
        }
    }
}

// MutationObserver setup (same as before)
const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (mutation.addedNodes.length) {
            changeServicesMenuText("Your New Menu Text");
        }
    });
});

const config = { childList: true, subtree: true };
observer.observe(document.body, config);

changeServicesMenuText("Your New Menu Text");
```

