require 'nokogiri'
require 'date'

require_relative 'gpx_point'

class GpxReader
  attr_reader :xml_doc

  def initialize(gpx:)
    self.xml_doc = Nokogiri::XML(gpx)
    self.xml_doc.remove_namespaces!
  end

  def points
    track_points = xml_doc.xpath("//trkpt")

		track_points.map do |point|
			timestamp_string = point.xpath("./time").text
			epoch_timestamp = convert_timestamp_to_epoch(timestamp: timestamp_string)

			GpxPoint.new(lat: point.attr('lat').to_f, lng: point.attr('lon').to_f, timestamp: epoch_timestamp)
		end
  end

  private

  attr_writer :xml_doc

  def convert_timestamp_to_epoch(timestamp:)
    DateTime.strptime(timestamp, '%Y-%m-%dT%H:%M:%SZ').to_time.to_i
  end
end
