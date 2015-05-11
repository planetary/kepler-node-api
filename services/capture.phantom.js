#!/usr/bin/env phantom

var system = require( 'system' ),
    config = JSON.parse(system.stdin.read()),
    page = require( 'webpage' ).create();

if ( config.width )
    page.viewportSize = {
        'width': config.width,
        'height': 1000
    };

if ( config.agent )
    page.settings.userAgent = config.agent;

page.open( config.target, function() {
    window.setTimeout( function () {
        system.stdout.write(page.renderBase64(config.format));
        phantom.exit();
    }, config.delay );
});
