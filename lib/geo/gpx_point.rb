class GpxPoint
	attr_reader :lat, :lng, :timestamp

  def initialize(lat:, lng:, timestamp:)
		self.lat = lat
		self.lng = lng
		self.timestamp = timestamp
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  protected

  def state
    [lat, lng, timestamp]
  end

	private

	attr_writer :lat, :lng, :timestamp
end
