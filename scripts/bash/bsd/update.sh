#!/bin/sh -u

# shellcheck source=/dev/null
. "/home/${SSH_USERNAME}/.profile";
pkg_add -UuI;
