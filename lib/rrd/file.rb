module RRD
  class File
    attr_reader :reader, :header, :data_start

    def initialize(file)
      @reader = RRD::Reader.new(file)
    end

    def close
      @reader.close if @reader
    end

    def header
      @header ||= begin
        header = RRD::Header.parse(reader)

        @data_start = reader.pos

        header
      end
    end

    def data(rra_index)
      RRD::Data.new(header.rra[rra_index], reader, header, @data_start)
    end

    def fetch(rra_index, options ={}, &block)
      data(rra_index).fetch(options, &block)
    end
  end
end