class GpsPointRepository
  attr_reader :points_with_timestamps

	def initialize(gpx_points: )
    self.points_with_timestamps = []
	end

  def initialize(gpx_points: nil, start_epoch: nil, duration_seconds: nil, points: nil)
    self.points_with_timestamps = []

		if gpx_points
			initialize_with_gpx_points(gpx_points: gpx_points)
		else
			initialize_with_interpolation(start_epoch: start_epoch, duration_seconds: duration_seconds, points: points)
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


	def initialize_with_gpx_points(gpx_points: )
    self.points_with_timestamps = gpx_points.map do |point|
      {
        point: [point.lat, point.lng],
        timestamp: point.timestamp
      }
    end
	end

	def initialize_with_interpolation(start_epoch:, duration_seconds:, points:)
    interval = duration_seconds / points.length.to_f

    points.each_with_index do |point, i|
      point_with_timestamp = {
        point: point,
        timestamp: (start_epoch  + (i * interval))
      }

      self.points_with_timestamps.push(point_with_timestamp)
    end
	end
end
