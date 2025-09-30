# carbonio-webui-i18n

![Contributors](https://img.shields.io/github/contributors/zextras/carbonio-webui-i18n "Contributors")
![Activity](https://img.shields.io/github/commit-activity/m/zextras/carbonio-webui-i18n "Activity") ![License](https://img.shields.io/badge/license-AGPL%203-green
"License")
![Project](https://img.shields.io/badge/project-carbonio-informational
"Project")
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/zextras.svg?style=social&label=Follow%20%40zextras)](https://twitter.com/zextras)

This repository contains all the resources needed to build a package with all
the localization resources for the web ui components of Carbonio.

## Overview

Carbonio WebUI i18n is a localization package that aggregates internationalization resources for various Carbonio web interface components. It provides translation files in JSON format for multiple Carbonio UI modules including:

- Admin Login UI
- Admin Manage UI
- Admin UI
- Auth UI
- Calendars UI
- Contacts UI
- Files UI
- Login UI
- Mails UI
- Search UI
- Shell UI
- Tasks UI
- Work Space Collaboration UI

## Structure

The package builds localization resources for two main environments:
- **Web UI**: Components located under `/opt/zextras/web/iris/`
- **Admin UI**: Components located under `/opt/zextras/admin/iris/`

Each UI component receives its own dedicated i18n directory with JSON translation files.

## Build Configuration

The project uses a PKGBUILD file to manage the build process and aggregate localization files from multiple source repositories. The yap.json configuration file defines the build parameters and project structure.

## Installation

The package installs localization files to specific paths under `/opt/zextras/` for both web and admin interfaces, making them available to the Carbonio application at runtime.

## License

See [COPYING](COPYING) file for details
