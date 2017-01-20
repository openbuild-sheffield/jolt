# Jolt
Swift web API and CMS that includes public documentation, built on top of the [Perfect](http://perfect.org) toolkit and utilising the [Stencil](https://github.com/kylef/Stencil) template system, you can develop applications rapidly and securely with the additional benift of [RAML documentation](http://raml.org). 

## Install

Currently needs MySQL as the database and the discount lib for generating Markdown

### Install Mac OS X

```
brew install discount
brew install mysql
```

### Install Linux

```
sudo apt-get install libmarkdown2-dev
sudo apt-get install mysql-server
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
```

Run:

```
.build/debug/Application
```

### For Production

To build a production ready release version, you would issue the command 

```
swift build -c release
```

This will place the resulting executable in the .build/release/ directory.

### Tips

It can be useful to wipe out all intermediate data and do a fresh build. Providing the --clean argument will delete the .build directory, and permit a fresh build. Providing the --clean=dist argument will delete both the .build directory and the Packages directory. Doing so will re-download all project dependencies to ensure you have the latest version of a dependent project.

```
swift build --clean
swift build --clean=dist
```

## License

Jolt is licensed under the GPL2 license. See [LICENSE](LICENSE) for more info.
