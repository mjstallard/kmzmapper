require 'spec_helper'
require 'pathname'

require 'geo/locus_kml_reader'

RSpec.describe LocusKmlReader do

  subject { LocusKmlReader.new(kml: File.open(Pathname.new(__dir__) + "../../fixtures/geo/doc.kml", "rb").read) }
  describe '#start_epoch' do
    it 'returns the unix timestamp version of the start time of the track' do
      expect(subject.start_epoch).to eq(1432629611)
    end
  end

  describe '#duration_seconds' do
    it 'returns the duration of the track in seconds' do
      expect(subject.duration_seconds).to eq(15388)
    end
  end

  describe '#points' do
    it 'returns the lat/long coordinates of the track as pairs, in the correct order' do
      expect(subject.points).to eq([
				[36.811302,-121.786952],
				[36.811311,-121.786936],
				[36.811339,-121.786929]
      ]
      )
    end
  end
end
