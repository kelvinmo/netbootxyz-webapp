# netboot.xyz web application standalone Docker container

A standalone Docker container with the netboot.xyz web application
(menu editor and local assets manager).

The default netboot.xyz Docker container bundles the web application along
with a web server and a TFTP server.  This container only packages
the web application, so you can pair it with web and TFTP servers of
your choice.

## How to use

This container exposes the web application on port 3000.

This container also needs volumes mapped to the following paths:

- `config` (menus)
- `assets` (local assets)

The web server should be configured to serve from the same directory
as the one mapped to `assets`.

The TFTP server should be configured to serve from the directory
as mapped to `config/menus`.

## Licence

Apache License 2.0
