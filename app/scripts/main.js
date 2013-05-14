require.config({
    paths: {
        Handlebars: '../components/require-handlebars-plugin/Handlebars',
        underscore: '../components/underscore-amd/underscore',
        jquery: '../components/jquery/jquery',
        jqueryui: '../components/jquery-ui/jqueryui',
        nested_view: './vendor/nested_view',
        bootstrap: 'vendor/bootstrap',
        chart: 'vendor/Chart',
        Backbone: '../components/backbone-amd/backbone',
        text: '../components/requirejs-text/text',
        json2: '../components/json2/json2',
        assessments: './views/assessments',
        home: './views/home',
        dashboard: './views/dashboard',
        components: './views/components',
        results: './views/results',
        stages: './views/stages',
        user: './views/user',
        routers: './routers',
        models: './models',
        controllers: './controllers',
        collections: './collections',
        helpers: './helpers',
        messages: './views/messages',
        toastr: '../components/toastr'
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        },
        chart: {
            exports: 'Chart'
        }
    }
});

require([
    'routers/main_router',
    'Backbone',
    './app_secrets_dev'
], function (
    MainRouter,
    Backbone,
    appConfig
    ) {
    'use strict';

    window.DEBUG = true;

    DEBUG && console.log("App Started");
    window.apiServerUrl = appConfig.apiServer;

    new MainRouter(appConfig);
    Backbone.history.start();
});
