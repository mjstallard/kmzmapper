require 'nokogiri'
require 'date'

class LocusKmlReader
  attr_reader :xml_doc

  def initialize(kml:)
    self.xml_doc = Nokogiri::XML(kml)
    self.xml_doc.remove_namespaces!
  end

  def start_epoch
    timestamp = xml_doc.at_xpath("//Placemark/name").text
    convert_timestamp_to_epoch(timestamp: timestamp)
  end

  def duration_seconds
    description = xml_doc.at_xpath("//Placemark/description").text
    duration_stamp = description.split("|")[0].strip
    duration_stamp.gsub!(/[a-z]/, '')
    (hours, minutes, seconds) = duration_stamp.split(':').map(&:to_i)

    (hours * 60 * 60) + (minutes * 60) + (seconds)
  end

  def points
    lines = xml_doc.at_xpath("//coordinates").text.strip.split("\n")
    lines.map do |line|
      line.split(",").map(&:strip)[0..1].map(&:to_f).reverse
    end
  end

  private
  attr_writer :xml_doc

  def convert_timestamp_to_epoch(timestamp:)
    DateTime.strptime(timestamp, '%Y-%m-%d %H:%M:%S').to_time.to_i
  end
end
