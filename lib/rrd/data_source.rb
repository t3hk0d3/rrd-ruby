module RRD
  class DataSource
    PARAMS = [
      :min_heartbeat, :min_value, :max_value
    ]

    attr_accessor :name, :type, :last_value, :last_ds, :unknown_seconds, :options

    def initialize(name, type, options = {})
      @name, @type = name, type
      @options = options
    end

    def self.parse(reader)
      name = reader.read_string(20, "A*")
      type = reader.read_string(20, "A*")
      params = Hash[PARAMS.zip(reader.read_uniparams(10))]

      options = {
        min_heartbeat: params[:min_heartbeat].to_i,
        min_value: params[:min_value].to_f,
        max_value: params[:max_value].to_f
      }
     
      DataSource.new(name, type, options)
    end

    def cdp
      @cdp ||= []
    end

    def inspect
      "<RRD::DataSource name='#{name}' type='#{type}' options='#{options}'>"
    end
  end
end