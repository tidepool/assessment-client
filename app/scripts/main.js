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
        Backbone: '../components/backbone-amd/backbone',
        text: '../components/requirejs-text/text',
        json2: '../components/require-handlebars-plugin/hbs/json2',
        assessments: './views/assessments',
        dashboard: './views/dashboard',
        components: './views/components',
        stages: './views/stages',
        routers: './routers',
        models: './models',
        collections: './collections',
        helpers: './helpers'
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

require(['routers/main_router', 'Backbone'], function (MainRouter, Backbone) {
    'use strict';

    console.log("App Started");
    var options = {
        definition: 3,
        forcefresh: true,
        apiServer: "http://api-server.dev",
        appId: "efd40076811c4a9566dd970642dc572151f9e45b75a2fd4f3d2956811b4066b5"
        // appId: "ddc5d7ba3b5f5e12dd7ca5938c9f5fea6fdf4e75f4d92f954367cc9e98700872"
    }
    new MainRouter(options);
    Backbone.history.start({pushState: true});
});
