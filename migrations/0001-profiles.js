require('coffee-script/register');

var config = require( '../config' ),
    models = require( '../models' ),

    mongoose = require( 'mongoose' );


mongoose.connect( config.mongo.uri, config.mongo.options );


exports.up = function(next) {
    models.Profile.create([
        {
            'name': 'default'
        }, {
            'name': '4k',
            'width': 3840,
        }, {
            'name': '1080p',
            'width': 1920
        }, {
            'name': '720p',
            'width': 1280
        }, {
            'name': 'imac',
            'width': 2560,
            'agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'
        }, {
            'name': 'mbp',
            'width': 1440,
            'agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'
        }, {
            'name': 'ipad-portrait',
            'width': 768,
            'agent': 'Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25'
        }, {
            'name': 'ipad-landscape',
            'width': 1024,
            'agent': 'Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25'
        }, {
            'name': 'iphone6-portrait',
            'width': 375,
            'agent': 'Mozilla/6.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/8.0 Mobile/10A5376e Safari/8536.25'
        }, {
            'name': 'iphone6-landscape',
            'width': 667,
            'agent': 'Mozilla/6.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/8.0 Mobile/10A5376e Safari/8536.25'
        }, {
            'name': 'iphone5-portrait',
            'width': 320,
            'agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_4 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B350 Safari/8536.25'
        }, {
            'name': 'iphone5-landscape',
            'width': 568,
            'agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_4 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B350 Safari/8536.25'
        }, {
            'name': 'iphone-portrait',
            'width': 320,
            'agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3'
        }, {
            'name': 'iphone-landscape',
            'width': 480,
            'agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3'
        }
    ])
    .then( function( models ) { next(); } )
    .catch( console.error.bind( console ) );
};

exports.down = function(next) {
    models.Profile.remove({})
    .then( function() { next(); } )
    .catch( console.error.bind( console ) );
};
