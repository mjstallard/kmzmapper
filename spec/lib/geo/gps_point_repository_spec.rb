require 'spec_helper'

require 'geo/gps_point_repository'

RSpec.describe GpsPointRepository do
  let(:start_epoch) { 1432629600 }
  subject do
    GpsPointRepository.new(
      start_epoch: start_epoch,
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

      coordinate = subject.find(time_epoch: start_epoch)
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(time_epoch: start_epoch + 4)

      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(time_epoch: start_epoch + 5)
      expect(coordinate).to eq(expected_coordinate)

      expected_coordinate = [-121.786936,36.811311]

      coordinate = subject.find(time_epoch: start_epoch + 6)
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(time_epoch: start_epoch + 12)
      expect(coordinate).to eq(expected_coordinate)

      expected_coordinate = [-121.786929,36.811339]

      coordinate = subject.find(time_epoch: start_epoch + 16)
      expect(coordinate).to eq(expected_coordinate)

      coordinate = subject.find(time_epoch: start_epoch + 22)
      expect(coordinate).to eq(expected_coordinate)
    end

    context 'when the time_epoch is before the start of the track' do
      it 'returns the first point' do
      expected_coordinate = [-121.786952,36.811302]

      coordinate = subject.find(time_epoch: start_epoch - 1)

      expect(coordinate).to eq(expected_coordinate)
      end
    end
  end
end
