require 'spec_helper'
require 'pathname'

require 'geo/gpx_reader'
require 'geo/gpx_point'

RSpec.describe GpxReader do

  subject { GpxReader.new(gpx: File.open(Pathname.new(__dir__) + "../../fixtures/geo/track.gpx", "rb").read) }
  describe '#points' do
    it 'returns GpxPoint objects with the lat/long coordinates and time stamp of the point as an epoch value, in the correct order' do
      expect(subject.points).to eq([
        GpxPoint.new(lat: 36.817201, lng: -121.859656, timestamp: 1452449996),
        GpxPoint.new(lat: 36.817249, lng: -121.859990, timestamp: 1452450006),
        GpxPoint.new(lat: 36.817284, lng: -121.860300, timestamp: 1452450016),
      ]
      )
    end
  end
end
