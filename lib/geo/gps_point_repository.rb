class GpsPointRepository
  attr_reader :points_with_timestamps

  def initialize(start_timestamp:, duration_seconds:, points:)
    self.points_with_timestamps = []

    initial_epoch = convert_kml_to_epoch(timestamp: start_timestamp)
    interval = duration_seconds / points.length.to_f

    points.each_with_index do |point, i|
      self.points_with_timestamps.push( {
        point: point,
        timestamp: (initial_epoch  + (i * interval))
      })
    end
  end

  def find(timestamp: )
    epoch = convert_canon_to_epoch(timestamp: timestamp)

    closest_match = points_with_timestamps.each_with_index.inject({}) do |best_match, (point, i)|
      difference = (point[:timestamp] - epoch).abs

      if best_match[:point].nil?
        { difference: difference, point: point }
      else
        difference >= best_match[:difference] ? best_match : { difference: difference, point: point }
      end
    end

    closest_match[:point][:point]
  end

  private

  attr_writer :points_with_timestamps

  def convert_kml_to_epoch(timestamp:)
    DateTime.strptime(timestamp, '%Y-%m-%d %H:%M:%S').to_time.to_i
  end

  def convert_canon_to_epoch(timestamp:)
    DateTime.strptime(timestamp, '%Y:%m:%d %H:%M:%S').to_time.to_i
  end
end
