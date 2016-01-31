# Stout Client


## Gulp Files
The primary gulp file is located at `build/gulpfile.coffee`. It describes all
build tasks.

## Build Configuration Files
Build configuration files are located at `build/config/` and describe how this 
project and it's various assets should be assembled/compiled. 

### build.yaml
This configuration file describes the build parameters and options which are
used by gulp and gulp build utilities, as well as describing the various source,
destination, and asset directories. Build configuration changes should be made
here whenever possible instead of within the gulpfile.

### webpack.config.coffee
This configuration file describes Webpack-specific configuration options. 
Changes to the Webpack build structure (such as adding loaders, etc.) should be
made here.


## Testing

### Selenium Testing
You can test your project on many different operating systems and browsers
using SauceLabs. The site doesn't need to be accessible via the internet if 
you install Sauce Connect. See https://wiki.saucelabs.com/display/DOCS/Setting+Up+Sauce+Connect 
for more information.