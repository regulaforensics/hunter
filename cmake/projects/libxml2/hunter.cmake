# Copyright (c) 2016, Ruslan Baratov, Alexandre Pretyman
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_pick_scheme)

hunter_add_version(
    PACKAGE_NAME libxml2
    VERSION "2.13.6"
    URL "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.13.6/libxml2-v2.13.6.tar.gz"
    SHA1 d60300b0aa243fe137d348bce0d9d8a0dca7c441
)

hunter_add_version(
    PACKAGE_NAME
    libxml2
    VERSION
    "2.12.10"
    URL
    "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.12.10/libxml2-v2.12.10.tar.gz"
    SHA1
    83bd1e1006bd7d669dc76e03242c0b722b5c593b
)

hunter_add_version(
    PACKAGE_NAME
    libxml2
    VERSION
    "2.9.7-p0"
    URL
    "https://github.com/hunter-packages/libxml2/archive/v2.9.7-p0.tar.gz"
    SHA1
    5d5d6da2a87267f160f76a26c5637cbc48b28784
)

hunter_pick_scheme(DEFAULT url_sha1_cmake)
hunter_cacheable(libxml2)
hunter_download(PACKAGE_NAME libxml2)
