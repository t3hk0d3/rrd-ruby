module RRD
  class Data

    attr_reader :reader, :rra, :header, :data_start

    def initialize(rra, reader, header, data_start)
      @rra = rra
      @reader = reader
      @header = header
      @data_start = data_start

      header.setup_reader(reader) # update endianess and alignment
    end

    def last_update
      @last_update ||= round_time(header.last_update.to_i)
    end

    def last_row
      reader.seek(base_position + rra.current_row * row_size)

      [last_update] + reader.read(row_size, unpack_formula)
    end
    
    def fetch(options = {}, &block)
      row = options[:start_row] || 0
      rows = [options[:rows] || rra.rows, rra.rows].min

      head = 

      last_update = round_time(header.last_update.to_i)
      current_time = last_update - (rra.rows * step_time)

      columns = [:time] + header.datasources.map(&:name).map(&:to_sym)

      if options[:start_time]
        start_time = round_time(options[:start_time].to_i)

        if current_time < start_time
          row = ((start_time - current_time) / step_time).floor
          current_time = start_time
        end
      end

      if options[:end_time]
        end_time = round_time(options[:end_time].to_i)

        if end_time < last_update
          rows = ((end_time - current_time) / step_time).ceil
        end
      end

      if row < head
        reader.seek(base_position + ((rra.current_row + 1 + row) * row_size))
      end

      data = []
      while row < rows
        if head && row >= head
          reader.seek(base_position + (row - head) * row_size) # jump to beginning
          head = nil
        end

        current_time += step_time

        row_data = [current_time] + reader.read(row_size, unpack_formula)

        row_data = block.call(row_data, columns, options) if block

        data << row_data

        row += 1
      end

      data
    end

    private

    def head
      @head ||= rra.rows - (rra.current_row + 1)
    end

    def tail
      rra.current_row
    end

    def unpack_formula
      @unpack_formula ||= "D" * ds_count
    end

    def base_position
      @base_position ||= data_start + rra.data_pointer
    end

    def step_time
      @step_time ||= header.step * rra.pdpr
    end

    def row_size
      @row_size ||= ds_count * 8
    end

    def ds_count
      @ds_count ||= header.datasources.size
    end

    def round_time(time)
      time - time % step_time
    end

  end
end