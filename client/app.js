requirejs.config({
    "baseUrl": "js/",
    "paths": {
        "client": "client",
        "jquery": "//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min",
        "easeljs": "easeljs-0.6.0.min",
        "bootstrap": "bootstrap",
        "three": "three.min",
        "cannon": "cannon.min",
        "box2d": "box2d"
    }
});

// Load the main app module to start the app
requirejs(["client/main"]);