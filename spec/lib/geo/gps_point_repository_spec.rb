require 'spec_helper'

require 'geo/gps_point_repository'
require 'geo/gpx_point'

RSpec.describe GpsPointRepository do
  let(:start_epoch) { 1432629600 }

  describe "when configured with GPX points" do
    subject do
      GpsPointRepository.new(
        gpx_points: [
          GpxPoint.new(lng: -121.786952, lat: 36.811302, timestamp: start_epoch),
          GpxPoint.new(lng: -121.786936, lat: 36.811311, timestamp: start_epoch + 10),
          GpxPoint.new(lng: -121.786929, lat: 36.811339, timestamp: start_epoch + 20),
        ]
      )
    end

    describe "#timestamps" do
      it "returns all the timestamps from the gpx points" do
        expected_timestamps = [start_epoch, start_epoch + 10, start_epoch + 20]

        expect(subject.timestamps).to eq(expected_timestamps)
      end
    end

    describe "#find" do
      it "returns the closest (by recency) recorded lat/long pair" do
        expected_coordinate = [36.811302,-121.786952]

        coordinate = subject.find(time_epoch: start_epoch)
        expect(coordinate).to eq(expected_coordinate)

        coordinate = subject.find(time_epoch: start_epoch + 4)

        expect(coordinate).to eq(expected_coordinate)

        coordinate = subject.find(time_epoch: start_epoch + 5)
        expect(coordinate).to eq(expected_coordinate)

        expected_coordinate = [36.811311,-121.786936]

        coordinate = subject.find(time_epoch: start_epoch + 6)
        expect(coordinate).to eq(expected_coordinate)

        coordinate = subject.find(time_epoch: start_epoch + 12)
        expect(coordinate).to eq(expected_coordinate)

        expected_coordinate = [36.811339,-121.786929]

        coordinate = subject.find(time_epoch: start_epoch + 16)
        expect(coordinate).to eq(expected_coordinate)

        coordinate = subject.find(time_epoch: start_epoch + 22)
        expect(coordinate).to eq(expected_coordinate)
      end

      context 'when the time_epoch is before the start of the track' do
        it 'returns the first point' do
        expected_coordinate = [36.811302,-121.786952]

        coordinate = subject.find(time_epoch: start_epoch - 1)

        expect(coordinate).to eq(expected_coordinate)
        end
      end
    end

  end

  describe "when configured with points and time information" do
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

    describe "#timestamps" do
      it "returns all the timestamps derived from the duration and interval" do
        expected_timestamps = [start_epoch, start_epoch + 10, start_epoch + 20]

        expect(subject.timestamps).to eq(expected_timestamps)
      end
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
end
