module RRD
  class Header
    COOKIE_STRING = "RRD\0"
    COOKIE_DOUBLE = 8.642135E130

    attr_reader :version, :last_update, :step, :endianess, :alignment

    attr_reader :rra, :datasources

    def initialize(options)
      @version = options[:version] || "0003"
      @last_update = options[:last_update] # || Time.now
      @step = options[:step] || 10
      @endianess = options[:endianess] || :little
      @alignment = options[:alignment] || 4

      @rra = options[:rra] || []
      @datasources = options[:datasources] || []
    end

    def setup_reader(reader)
      reader.endianess = endianess
      reader.alignment = alignment
    end

    def self.parse(reader)
      reader.seek(0) # rewind to start

      read_cookie(reader)

      options = {}

      options[:version] = reader.read(5, "a*").first

      read_double_cookie(reader, options)

      datasources_count, rra_count, @step = reader.read(24, "QQQ")

      global_params = reader.read_uniparams(10)

      options[:datasources] = []
      datasources_count.times do |i|
        options[:datasources] << RRD::DataSource.parse(reader)
      end

      options[:rra] = []
      rra_pointer = 0
      rra_count.times do |i|
        rra = RRD::Archive.parse(reader)

        rra.data_pointer = rra_pointer
        rra_pointer += rra.rows * datasources_count * 8

        options[:rra] << rra
      end

      last_update, last_update_msec = reader.read(16, "QQ")

      options[:last_update] = Time.at(last_update.to_f + (last_update_msec.to_f / 1000000))

      datasources_count.times do |i|
        datasource = options[:datasources][i]

        datasource.last_ds = reader.read_string(30, "A*")
        reader.align
        params = reader.read_uniparams(10)
        datasource.unknown_seconds = params[0].to_i
        datasource.last_value = params[1].to_f
      end

      rra_count.times do |rra_index|
        datasources_count.times do |ds_index|
          cdp = RRD::CDP.parse(reader, options[:rra][rra_index])
          options[:rra][rra_index].cdp[ds_index] = cdp
          options[:datasources][ds_index].cdp[rra_index] = cdp
        end
      end

      rra_count.times do |rra_index|
        options[:rra][rra_index].current_row = reader.read(8, "Q").first
      end

      Header.new(options)
    end    

    private

    def self.read_cookie(reader) 
      raise "Invalid RRD file" unless reader.read_string(4) == COOKIE_STRING
    end

    def self.read_double_cookie(reader, options)
      reader.read(3) # skip 32-bit alignment
      part = reader.read_string(4) # 64-bit alignment or first part of double-cookie

      if part == "\0\0\0\0" # RRD made on 64-bit system
        cookie = reader.read_string(8)
        options[:alignment] = 8
      else # made on 32-bit system
        cookie = part + reader.read_string(4)
        options[:alignment] = 4
      end

      case COOKIE_DOUBLE
      when cookie.unpack("G").first
        options[:endianess] = :big
      when cookie.unpack("E").first
        options[:endianess] = :little
      else
        raise "Unknown architecture!"
      end

      reader.endianess = options[:endianess]
      reader.alignment = options[:alignment]
    end
  end
end