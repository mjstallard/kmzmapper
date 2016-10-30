require 'spec_helper'

require 'geo/gps_point_repository'

RSpec.describe GpsPointRepository do
  subject do
    GpsPointRepository.new(
      start_epoch: 1432629600, # 2015:05:26 08:40:00.00
      duration_seconds: 30,
      points: [
        [-121.786952,36.811302],
        [-121.786936,36.811311],
        [-121.786929,36.811339]
      ]
    )
  end

  describe "#find" do
    it "returns the closest (by recency) recorded lat/long pair" do
      expected_coordinate = [-121.786952,36.811302]

      coordinate = subject.find(timestamp: '2015:05:26 08:40:00.00')
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(timestamp: '2015:05:26 08:40:04.00')
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(timestamp: '2015:05:26 08:40:05.00')
      expect(coordinate).to eq(expected_coordinate)

      expected_coordinate = [-121.786936,36.811311]

      coordinate = subject.find(timestamp: '2015:05:26 08:40:06.00')
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(timestamp: '2015:05:26 08:40:12.00')
      expect(coordinate).to eq(expected_coordinate)

      expected_coordinate = [-121.786929,36.811339]

      coordinate = subject.find(timestamp: '2015:05:26 08:40:16.00')
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(timestamp: '2015:05:26 08:40:20.00')
      expect(coordinate).to eq(expected_coordinate)
    end

    context 'when the timestamp is before the start of the track' do
      it 'returns the first point' do
      expected_coordinate = [-121.786952,36.811302]

      coordinate = subject.find(timestamp: '1983:05:26 08:40:00.00')
      expect(coordinate).to eq(expected_coordinate)
      end
    end
  end
end
