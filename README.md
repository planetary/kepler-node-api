# Kepler

Screenshot service

## Dependencies

* NodeJS
* MongoDB
* PhantomJS
* AWS bucket

## Installation
* `sudo npm install -g gulp migrate mocha`
* `npm install`
* `gulp build`

## Serve Locally
* gulp

### OSX Cheatsheet

#### mongo
```bash
brew install mongodb &&
ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents &&
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
```
