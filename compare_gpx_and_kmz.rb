#!/usr/bin/env ruby
require 'mini_exiftool'

require_relative 'lib/geo/locus_kml_reader'
require_relative 'lib/geo/gpx_reader'
require_relative 'lib/geo/gps_point_repository'

def distance_between(lat1, lon1, lat2, lon2)
  rad_per_deg = Math::PI / 180
  rm = 6371000 # Earth radius in meters

  lat1_rad, lat2_rad = lat1 * rad_per_deg, lat2 * rad_per_deg
  lon1_rad, lon2_rad = lon1 * rad_per_deg, lon2 * rad_per_deg

  a = Math.sin((lat2_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2) ** 2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

  rm * c # Delta in meters
end

if ARGV.length < 2
  puts "usage: ./compare_gpx_and_kmz.rb <path_to_kml_file> <path_to_gpx_file> <kml_track_timezone>"
  exit 1
end

path_to_kml_file = ARGV[0]
path_to_gpx_file = ARGV[1]
gps_track_timezone = ARGV[2]

if gps_track_timezone != 'PST'
  puts "Only 'PST' is currently supported as a gps_track_timezone"
  exit 1
end

kml_content = File.open(path_to_kml_file, "rb").read
kml_reader = LocusKmlReader.new(kml: kml_content)

adjusted_start_epoch = kml_reader.start_epoch + (7 * 60 * 60)

kml_gps_points_repository = GpsPointRepository.new(start_epoch: adjusted_start_epoch,
                                                duration_seconds: kml_reader.duration_seconds,
                                                points: kml_reader.points)

gpx_content = File.open(path_to_gpx_file, "rb").read
gpx_reader = GpxReader.new(gpx: gpx_content)

gpx_gps_points_repository = GpsPointRepository.new(gpx_points: gpx_reader.points)

puts "epoch, gpx_lat, gpx_lon, kml_lat, kml_lon, difference_meters"
gpx_gps_points_repository.timestamps.each do |ts|
  gpx_coordinates = gpx_gps_points_repository.find(time_epoch: ts)
  kml_coordinates = kml_gps_points_repository.find(time_epoch: ts)
  distance_difference = distance_between(gpx_coordinates[0], gpx_coordinates[1], kml_coordinates[0], kml_coordinates[1])

  puts [ts, gpx_coordinates, kml_coordinates, distance_difference].flatten.join(",")
end

