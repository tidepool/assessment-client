require.config({
    // TODO: Revisit usign HBS (that's why commented out)
    // Seems to be working for him, but something wrong now
    // http://alexsexton.com/blog/2012/03/my-thoughts-on-amd/
    // hbs : {
    //   templateExtension : 'hbs',
    //   // if disableI18n is `true` it won't load locales and the i18n helper
    //   // won't work as well.
    //   disableI18n : true
    // },
    paths: {
        Handlebars: '../components/require-handlebars-plugin/Handlebars',
        // i18nprecompile: '../components/require-handlebars-plugin/hbs/i18nprecompile',
        // hbs: '../components/require-handlebars-plugin/hbs',
        // handlebars: '../components/handlebars.js/dist/handlebars',
        underscore: '../components/underscore-amd/underscore',
        jquery: '../components/jquery/jquery',
        jqueryui: '../components/jquery-ui/jqueryui',
        nested_view: './vendor/nested_view',
        bootstrap: 'vendor/bootstrap',
        chart: 'vendor/Chart',
        Backbone: '../components/backbone-amd/backbone',
        text: '../components/requirejs-text/text',
        json2: '../components/require-handlebars-plugin/hbs/json2',
        assessments: './views/assessments',
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
        messages: './views/messages'
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        },
        chart: {
            exports: 'Chart'
        }
        // handlebars: {
        //     exports: 'Handlebars'
        // }
    }
});

require(['routers/main_router', 'underscore', 'Backbone', './app_secrets_dev'], function (MainRouter, _, Backbone, AppConfig) {
    'use strict';

    console.log("App Started");
    var options = { definition: 1 }

    options = _.extend(options, AppConfig);
    Backbone.history.start({pushState: false});

    new MainRouter(options);
});
