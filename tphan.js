var page = require('webpage').create(),
    system = require('system'),
    t, address;

page.onConsoleMessage = function (msg) {
    console.log(msg);
};
// page.onResourceRequested = function (request) {
//     console.log('Request ' + JSON.stringify(request, undefined, 4));
// };
// page.onResourceReceived = function (response) {
//     console.log('Receive ' + JSON.stringify(response, undefined, 4));
// };
if (system.args.length === 1) {
    console.log('Usage: loadspeed.js <some URL>');
    phantom.exit();
}

t = Date.now();
address = system.args[1];
page.open(address, function (status) {
    if (status !== 'success') {
        console.log('FAIL to load the address');
    } else {
        t = Date.now() - t;
        console.log('Loading time ' + t + ' msec');
    }
    
    phantom.exit();
});