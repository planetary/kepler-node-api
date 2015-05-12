# Kepler-NodeJS-API

Screenshot service (nodejs API)

## Install

```bash
npm install --save kepler-api
```

## Usage

```javascript
kepler = require('kepler-api')

kepler.configure({
    'apiUrl': 'http://your-kepler-server',
    'projectSlug': 'your-project-slug',
    'apiKey': 'your-api-key',
    'screenshotDefaults': {
        'versions': ['iphone-portrait', 'ipad-portrait', '1080p']
    }
})


kepler.capture('http://your-website-here/a-random-page', )
```

## API Reference

TODO: write this
