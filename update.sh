#!/bin/sh

##
# A helper script for updates

if [ -f "composer.phar" ]; then
	current="composer.phar"
else
	printf "Run from repo.\n"
fi

loc=$(mktemp -t composer)
curl -s -L https://getcomposer.org/composer.phar \
	-o $loc

hash_current=$(md5 -r "$current" | cut -d' ' -f1)
hash_new=$(md5 -r "$loc" | cut -d' ' -f1)

if [ $hash_current != $hash_new ]; then
	
	changelog="debian/changelog"
	tempfile=$(mktemp -t debcontrol)
	
	current_date="$(date +"%Y%m%d")"
	rfc2822_date=$(date +"%a, %d %b %Y %T %z")
	version="1.0.0-dev-$current_date"


	composer_ver=$(php $loc --version | cut -d' ' -f3 | cut -b 6-12)
	printf "Updating..."
	mv $loc $current
	echo "php-composer ($version-0+precise1) precise; urgency=low

  * Upstream release $version ($composer_ver).

 -- Ross Duggan <ross.duggan@acm.org>  $rfc2822_date
" > $changelog
	sed "s/1.0.0-dev-[0-9]*/1.0.0-dev-$current_date/g" \
	"$changelog" > "$tempfile" && mv "$tempfile" "$changelog" && \
	git commit -m "$version (upstream $composer_ver)" debian composer.phar && \
	git tag -a $version -m $version
	printf "Ready to push.\n"
else
	# Cleanup
	rm $loc
	printf "No changes since last update.\n"
fi

