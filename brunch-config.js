exports.config = {
  files: {
    javascripts: {
      joinTo: "js/app.js",
      order: {
        before: [
          "bower_components/jquery/dist/jquery.min.js",
          "bower_components/bootstrap/dist/js/bootstrap.min.js"
        ]
      }
    },
    stylesheets: { joinTo: "css/app.css" },
    templates:   { joinTo: "js/app.js" }
  },

  conventions: {
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],
    // Where to compile files to
    public: "priv/static"
  },

  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [ /web\/static\/vendor/,
        /bower_components\/ag-grid\/dist\/ag-grid.min.js/]
    },
    copycat:{
      "fonts" : ['bower_components/material-design-iconic-font/dist/fonts'], verbose: false
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html"]//, "react", "react-dom"]
  }
};
