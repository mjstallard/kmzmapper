#!/usr/bin/env ruby
require 'mini_exiftool'

require_relative 'lib/geo/gpx_reader'
require_relative 'lib/geo/gps_point_repository'

if ARGV.length < 2
  puts "usage: ./apply_gpx_track.rb <path_to_gpx_file> <directory_containing_images>"
  exit 1
end

path_to_gpx_file = ARGV[0]
images_directory  = ARGV[1]

gpx_content = File.open(path_to_gpx_file, "rb").read
gpx_reader = GpxReader.new(gpx: gpx_content)

gps_points_repository = GpsPointRepository.new(gpx_points: gpx_reader.points)

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
