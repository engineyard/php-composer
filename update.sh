#!/bin/sh

##
# A helper script for updates

if [ -f "composer.phar" ]; then
	current="composer.phar"
else
	printf "Run from repo.\n"
fi

errexit() {
	echo "$1 required"
	exit 1
}

# Check available commands
for cmd in php curl git
do
	command -v $cmd > /dev/null || errexit $cmd
done

hash_current=$(php $current --version | cut -d' ' -f3 | cut -b 6-12)
hash_new=$(curl -s -L https://getcomposer.org/version | cut -b 1-7)

if [ $hash_current != $hash_new ]; then

	printf "New composer found, downloading...\n"
	loc=$(mktemp -d -t composer) && mkdir -p $loc
	curl -s -L https://getcomposer.org/composer.phar \
		-o $loc/composer.phar
	
	changelog="debian/changelog"
	tempfile=$(mktemp -t debcontrol)
	
	current_date="$(date +"%Y%m%d")"
	rfc2822_date=$(date +"%a, %d %b %Y %T %z")
	version="1.0.0-dev-$current_date"
	composer_ver=$hash_new

	printf "Testing..."
	cp test/composer.json $loc/
	cp test/composer.lock $loc/

	cwd=`pwd`
	cd $loc
	php composer.phar install > $loc/build.log || exit 1
	cd $cwd
	printf "OK.\n"

	printf "Updating..."
	mv $loc/composer.phar $current
	echo "php-composer ($version-0+precise1) precise; urgency=low

  * Upstream release $version ($composer_ver).

 -- Ross Duggan <ross.duggan@acm.org>  $rfc2822_date
" > $changelog
	sed "s/1.0.0-dev-[0-9]*/1.0.0-dev-$current_date/g" \
	"$changelog" > "$tempfile" && mv "$tempfile" "$changelog" && \
	git commit -m "$version (upstream $composer_ver)" debian composer.phar && \
	git tag -a $version -m $version
	rm -rf $loc
	printf "Ready to push.\n"
else
	printf "No changes since last update.\n"
fi

