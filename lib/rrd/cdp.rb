module RRD
  class CDP
    CDP_val = 0
    CDP_unkn_pdp_cnt = 1
    CDP_hw_intercept = 2
    CDP_hw_seasonal = 2
    CDP_seasonal_deviation = 2
    CDP_hw_last_intercept = 3
    CDP_hw_last_seasonal = 3
    CDP_last_seasonal_deviation = 3
    CDP_hw_slope = 4
    CDP_hw_last_slope = 5
    CDP_null_count = 6
    CDP_init_seasonal = 6
    CDP_last_null_count = 7
    CDP_primary_val = 8
    CDP_secondary_val = 9

    def initialize(options)
      @options = options
    end

    def self.parse(reader, rra)
      params = reader.read_uniparams(10)

      options = {
        primary_value: params[CDP_primary_val].to_f,
        secondary_value: params[CDP_secondary_val].to_f
      }

      case rra.cf
      when :hwpredict, :mhwpredict
        options[:intercept] = params[CDP_hw_intercept].to_f
        options[:last_intercept] = params[CDP_hw_intercept].to_f
        options[:slope] = params[CDP_hw_intercept].to_f
        options[:last_slope] = params[CDP_hw_intercept].to_f
        options[:null_count] = params[CDP_hw_intercept].to_i
        options[:last_null_count] = params[CDP_hw_intercept].to_i
      when :seasonal
        options[:seasonal] = params[CDP_hw_seasonal].to_f
        options[:last_seasonal] = params[CDP_hw_last_seasonal].to_f
        options[:init_seasonal] = params[CDP_init_seasonal].to_i
      when :devseasonal
        options[:seasonal_deviation] = params[CDP_seasonal_deviation].to_f
        options[:last_seasonal_deviation] = params[CDP_last_seasonal_deviation].to_f
        options[:init_seasonal] = params[CDP_init_seasonal].to_i
      else
        options[:value] = params[CDP_val].to_f
        options[:unknown_datapoints] = params[CDP_unkn_pdp_cnt].to_i
      end

      new(options)
    end
  end
end