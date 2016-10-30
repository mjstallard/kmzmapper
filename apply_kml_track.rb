#!/usr/bin/env ruby
require 'mini_exiftool'

require_relative 'lib/geo/locus_kml_reader'
require_relative 'lib/geo/gps_point_repository'

if ARGV.length < 3
  puts "usage: ./apply_kml_track.rb <path_to_kml_file> <directory_containing_images> <timezone>"
  exit 1
end

path_to_kml_file = ARGV[0]
images_directory  = ARGV[1]
timezone = ARGV[2]

if timezone != 'PST'
  puts "Only 'PST' is currently supported as a timezone"
  exit 1
end

kml_content = File.open(path_to_kml_file, "rb").read

kml_reader = LocusKmlReader.new(kml: kml_content)

adjusted_start_epoch = kml_reader.start_epoch + (7 * 60 * 60)

gps_points_repository = GpsPointRepository.new(start_epoch: adjusted_start_epoch,
                                                duration_seconds: kml_reader.duration_seconds,
                                                points: kml_reader.points)

Dir.glob(images_directory + '/*.jpg') do |jpg|
  image_exif = MiniExiftool.new(jpg)
  created_date = image_exif.createdate
  puts created_date
  coordinate = gps_points_repository.find(time_epoch: created_date.to_i)
  puts "#{jpg}: #{coordinate}"
  image_exif.gpslatitude = coordinate[0]
  image_exif.gpslatituderef = coordinate[0] >= 0 ? 'N' : 'S'
  image_exif.gpslongitude = coordinate[1]
  image_exif.gpslongituderef = coordinate[1] >= 0 ? 'E' : 'W'
  image_exif.save
  puts "saved!"
end
