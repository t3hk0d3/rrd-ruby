module RRD
  class Reader

    class Unival

      def initialize(data, endianess)
        @data, @little_endian = data.first, endianess == :little
      end

      def to_i
        @data.unpack("Q" + (@little_endian ? "<" : ">")).first
      end

      def to_f
        @data.unpack(@little_endian ? "E" : "G").first
      end

      def inspect
        "<#{to_i}/#{to_f}>"
      end

    end

    attr_reader :file

    attr_accessor :endianess, :alignment

    def initialize(filename)
      @file = ::File.open(filename, "rb")
      @endianess = :little
      @alignment = 4
    end

    def seek(position, mode = :absolute)
      modes = {
        absolute: IO::SEEK_SET,
        eof: IO::SEEK_END,
        relative: IO::SEEK_CUR
      }

      file.seek(position.to_i, modes[mode] || raise("Unknown seek mode '#{mode}'"))
    end

    def pos
      file.pos
    end

    def align
      skip = (alignment - (file.pos % alignment)) % alignment
      file.read(skip) if skip
    end

    def read(size, symbol = "a*", options = {})
      align if options[:align]

      file.read(size).unpack(endian(symbol))
    end

    def read_string(size, symbol = "a*")
      read(size, symbol).first
    end

    def read_uniparams(size)
      size.times.map do |i|
        Unival.new(read(8, "a*"), endianess)
      end
    end

    def close
      @file.close if @file
    end

    private

    def symbol_cache
      @symbol_cache ||= {}
    end

    def endian(symbol)
      symbol_cache[symbol] ||= begin
        symbol.gsub!(/([sSiIlLqQ][_!]*)/, "\\1" + (little_endian? ? "<" : ">"))
        symbol.gsub!(/[Dd]/, (little_endian? ? "E" : "G"))
        symbol.gsub!(/[Ff]/, (little_endian? ? "e" : "g"))
        symbol
      end
    end

    def little_endian?
      endianess == :little
    end

  end
end