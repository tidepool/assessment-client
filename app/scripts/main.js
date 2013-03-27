require.config({
    paths: {
        jquery: '../components/jquery/jquery',
        Backbone: '../components/backbone-amd/backbone',
        bootstrap: 'vendor/bootstrap'
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        }
    }
});

require(['app', 'jquery', 'Backbone', 'bootstrap'], function (app, $, Backbone) {
    'use strict';
    // use app here
    console.log(app);
    console.log('Running jQuery %s', $().jquery);
});