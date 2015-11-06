require 'time'

class TimeHash

  attr_accessor :automatic_expiration
  attr_reader :times

  def initialize(automatic_expiration = true)
    @automatic_expiration = automatic_expiration
    @times = {}
    @internal = {}
  end

  def expire!
    @times.clone.each do |key, times|
      if expired?(key)
        @internal.delete(key)
        @times.delete(key)
      end
    end
    self
  end

  def expired?(key)
    return true unless @times.has_key?(key)
    time, ttl = @times[key]
    Time.now - time > ttl
  end

  def put(key, value, ttl) # ms
    expire!
    response = (@internal[key] = value)
    @times[key] = [Time.now, ttl]
    response
  end

  ConfusionError = Class.new(StandardError)

  def []=(*args)
    raise(ConfusionError,
          "Don't use standard key-value assignment with TimeHashes, please.")
  end

  # before sending to any methods on the wrapped hash,
  # expire things.
  Hash.instance_methods.each do |method|
    next if method == :[]=
    define_method(method) do |*args, &block|
      expire! if @automatic_expiration
      @internal.send(method, *args, &block)
    end
  end
end
