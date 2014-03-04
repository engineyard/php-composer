#!/bin/sh

if command -v hhvm > /dev/null; then
    hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 /usr/lib/composer/composer.phar $*
elif command -v php > /dev/null; then
    php -d open_basedir= -d allow_url_fopen=On -d detect_unicode=Off -d apc.enable_cli=0 /usr/lib/composer/composer.phar $*
else
    echo "composer requires PHP/HHVM to run"
    exit 1
fi
