# Kepler-NodeJS-API

Nodejs API for [Kepler](https://github.com/planetary/kepler)

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
        'delay': 0
    }
})


kepler.capture('http://your-website-here/a-random-page', 'page-name-here')
```

## API Reference

TODO: write this
