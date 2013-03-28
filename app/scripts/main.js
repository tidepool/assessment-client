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
        Backbone: '../components/backbone-amd/backbone',
        text: '../components/requirejs-text/text',
        json2: '../components/require-handlebars-plugin/hbs/json2'
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        }
        // handlebars: {
        //     exports: 'Handlebars'
        // }
    }
});

require(['./routers/assessments_router', 'Backbone'], function (AssessmentsRouter, Backbone) {
    'use strict';

    console.log("Hello world");
    new AssessmentsRouter();
    Backbone.history.start();
});
