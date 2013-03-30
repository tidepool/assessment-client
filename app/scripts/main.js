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
        jquery_draggable: '../components/jquery-ui/ui/jquery.ui.draggable',
        jquery_droppable: '../components/jquery-ui/ui/jquery.ui.droppable',
        Backbone: '../components/backbone-amd/backbone',
        text: '../components/requirejs-text/text',
        json2: '../components/require-handlebars-plugin/hbs/json2',
        assessments: './views/assessments',
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
        definition: 1,
        apiServer: "http://api-server.dev",
        appId: "efd40076811c4a9566dd970642dc572151f9e45b75a2fd4f3d2956811b4066b5"
    }
    new MainRouter(options);
    Backbone.history.start({pushState: true});
});
