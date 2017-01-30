# Jolt
Swift web API and CMS that includes public documentation, built on top of the [Perfect](http://perfect.org) toolkit and utilising the [Stencil](https://github.com/kylef/Stencil) template system, you can develop applications rapidly and securely with the additional benefit of [RAML documentation](http://raml.org).

Automatically creates routes:
* /api.raml - For serving developer documentation, more formats to follow
* /sitemap.xml -

## Install

Currently needs MySQL as the database and the discount lib for generating Markdown

### Install Mac OS X

```
brew install discount
brew install mysql

#for dev you will need to install the following
brew install sassc

```

### Install Linux

```
sudo apt-get install libmarkdown2-dev
sudo apt-get install mysql-server

#for dev you will need to install the following
sudo apt-get install libsass

```

### Create config

You will need to copy file config.plist.dist to config.plist and amend as required.  This file sets the theme to use, the datastore connection details, security details and modules to load, [more details to follow later](https://github.com/openbuild-sheffield/jolt/wiki/Main-config) in the wiki.

## Code Structure

The code is build using standard modules as per Swifts documentation and most of the the code resides in 'Sources' directory.  Items outside of 'Sources' can be edited when the application is running.

### Public

This directory contains the web root for static content

### Themes

Should contain directories for each installed theme, currently only 'basic' is available.  Themes use the [Stencil](https://github.com/kylef/Stencil) template system.

### Views

Views are unthemed and unstyled, currently has sitemap.xml and api.raml

### Sources

Contains the core Swift code and additional modules.  The 'Application' directory and anything prefixed with 'Openbuild' is core to the framework.  Anything prefixed with 'Route' can be considered an optional module that plugs in functionality to the system.  The [documentation for creating a module](https://github.com/openbuild-sheffield/jolt/wiki/Create-Module) can be found in the wiki, work in progress...

## Building the application

### For Development

Build:

```
swift build

#Or if you are using the gulp scripts
gulp build-swift-dev

```

Run:

```
.build/debug/Application
```

### For Production

To build a production ready release version, you would issue the command

```
swift build -c release

#Or if you are using the gulp scripts
gulp build-swift-release

```

This will place the resulting executable in the .build/release/ directory.

### Tips

It can be useful to wipe out all intermediate data and do a fresh build. Providing the --clean argument will delete the .build directory, and permit a fresh build. Providing the --clean=dist argument will delete both the .build directory and the Packages directory. Doing so will re-download all project dependencies to ensure you have the latest version of a dependent project.

```
swift build --clean
swift build --clean=dist
```

## Web assets

The code includes node gulp scripts to help with css and javascript files, you will need to install node and npm.

To install the scripts run:

```
npm install

npm install jspm -g

jspm install -y

#You can then optionally do the following:

#Watch the file system for changes to sass and js file, then test and concat
gulp watch

#Review the files - js only at present with jslint
gulp review

#Build the css and js file
gulp build

```

Your javascript and sass files are stored in the WebSource directory

## Notes

Current focus is on creating APIs and documentation, CMS and additional modules later...

## License

Jolt is licensed under the GPL2 license. See [LICENSE](LICENSE) for more info.
