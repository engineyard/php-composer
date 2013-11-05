# PHP-Composer

This is [PHP Composer](https://github.com/composer/composer), debianized.

## Installation

This is packaged on Launchpad, at [https://launchpad.net/composer](https://launchpad.net/composer).

Add the PPA:

```
apt-add-repository -y ppa:duggan/composer
apt-get update
```

Then install with:

```
apt-get install php5-composer
```

## Updates

Releases are tagged with a date, as the composer project itself does not hold
to any useful versioning mechanism.

The PPA is set up for daily builds, though I expect this to settle into a
roughly weekly cadence of release.

To update:

```
apt-get update
apt-get install --only-upgrade php5-composer
```
