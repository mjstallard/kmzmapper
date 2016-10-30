# kmzmapper

A tool to annotate images using data from KML (and one day, as the name suggests, from KMZ) files.

# Installation

You'll need Ruby 2.3.1 and `exiftool`.

Use the ruby manager of your choice to install the required ruby version (I use [rbenv](https://github.com/rbenv/rbenv)).

Exiftool can be installed via brew:

```
$ brew install exiftool
```

Once you have it installed, install the dependencies using bundler:

```
$ gem install bundler
$ bundle
```

You should then be able to run the script using the following:

```
$ ./apply_kml_track.rb <path_to_kml_file> <directory_containing_images> <gps_track_timezone>
```

Note that only PST is supported as a GPS track timezone for now.

This script will update the EXIF data in situ.

# Tests

There are specs for the underlying parsing/GPS point inference code. You can run them with the following command:

```
$ bundle exec rspec
```
