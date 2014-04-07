module RRD
  class Archive
    RRA_cdp_xff_val = 0
    RRA_hw_alpha = 1
    RRA_hw_beta = 2
    RRA_dependent_rra_idx = 3
    RRA_period = 4
    RRA_seasonal_gamma = 1
    RRA_seasonal_smoothing_window = 2
    RRA_seasonal_smooth_idx = 4
    RRA_delta_pos = 1
    RRA_delta_neg = 2
    RRA_window_len = 4
    RRA_failure_threshold = 5

    attr_reader :cf, :rows, :pdpr, :options

    attr_accessor :current_row, :data_pointer

    def initialize(cf, rows, per_row, options)
      @cf, @rows, @pdpr, @options = cf, rows, per_row, options
    end

    def cdp
      @cdp ||= []
    end

    def self.parse(reader)
      cf = reader.read_string(20, "A*").downcase.to_sym
      rows, pdpr = reader.read(16, "QQ", align: true)

      params = reader.read_uniparams(10)

      options = {}

      case cf
      when :hwpredict, :mhwpredict
        options[:alpha] = params[RRA_hw_alpha].to_f
        options[:beta]  = params[RRA_hw_beta].to_f
      when :seasonal, :devseasonal
        options[:gamma] = params[RRA_seasonal_gamma].to_f
        options[:smoothing_window]  = params[RRA_seasonal_smoothing_window].to_f
      when :failures
        options[:delta_pos] = params[RRA_delta_pos].to_f
        options[:delta_neg] = params[RRA_delta_neg].to_f
        options[:failure_threshold] = params[RRA_failure_threshold].to_i
        options[:window_length] = params[RRA_window_len].to_i
      when :devpredict
      else
        options[:xff] = params[RRA_cdp_xff_val].to_f
      end
      
      Archive.new(cf, rows, pdpr, options)
    end

  end
end