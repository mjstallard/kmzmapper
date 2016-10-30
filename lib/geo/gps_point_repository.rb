class GpsPointRepository
  attr_reader :points_with_timestamps

  def initialize(start_epoch:, duration_seconds:, points:)
    self.points_with_timestamps = []

    interval = duration_seconds / points.length.to_f

    points.each_with_index do |point, i|
      self.points_with_timestamps.push( {
        point: point,
        timestamp: (start_epoch  + (i * interval))
      })
    end
  end

  def find(time_epoch: )
    closest_match = points_with_timestamps.each_with_index.inject({}) do |best_match, (point, i)|
      difference = (point[:timestamp] - time_epoch).abs
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
end
