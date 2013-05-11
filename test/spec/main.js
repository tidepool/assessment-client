console.log("Main called");

require.config({
    // Set baseUrl to the root folder
    baseUrl: '../',
    paths: {
        // Bower installed dependency paths
        Handlebars: './components/require-handlebars-plugin/Handlebars',
        // i18nprecompile: '../components/components/require-handlebars-plugin/hbs/i18nprecompile',
        // hbs: '../components/components/require-handlebars-plugin/hbs',
        // handlebars: '../components/components/handlebars.js/dist/handlebars',
        underscore: './components/underscore-amd/underscore',
        jquery: './components/jquery/jquery',
        jqueryui: './components/jquery-ui/jqueryui',
        Backbone: './components/backbone-amd/backbone',
        text: './components/requirejs-text/text',
        json2: './components/json2/json2',
        toastr: './components/toastr',

        // External but not Bower installed, they are downloaded manually
        nested_view: './scripts/vendor/nested_view',
        bootstrap: './scripts/vendor/bootstrap',
        chart: './scripts/vendor/Chart',

        // Application paths
        assessments: './scripts/views/assessments',
        home: './scripts/views/home',
        dashboard: './scripts/views/dashboard',
        components: './scripts/views/components',
        results: './scripts/views/results',
        stages: './scripts/views/stages',
        user: './scripts/views/user',
        routers: './scripts/routers',
        models: './scripts/models',
        controllers: './scripts/controllers',
        collections: './scripts/collections',
        helpers: './scripts/helpers',
        messages: './scripts/views/messages'
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        },
        chart: {
            exports: 'Chart'
        },
        mocha: {
            attach: 'mocha'
        }
        // handlebars: {
        //     exports: 'Handlebars'
        // }
    }
});

// require(['require',
//     'chai', 
//     'chai_jquery'], function (require, chai, jqueryChai) {
    // 'use strict';

    // Mocha is a global variable, so accessible here
    // mocha.setup({
    //     ui: 'bdd',
    //     ignoreLeaks: true
    // });

    // console.log("Mocha setup");

    // window.chai = chai
    // window.expect = chai.expect;
    // window.assert = chai.assert;
    // window.jqueryChai = jqueryChai;

    // chai.use(window.jqueryChai);

require(['./spec/models/user_spec'], function(module) {
    console.log("module: ", module);
    if (navigator.userAgent.indexOf('PhantomJS') < 0) {
        mocha.run();
    } 
});
// });