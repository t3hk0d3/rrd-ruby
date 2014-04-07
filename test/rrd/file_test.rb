require 'test_helper'

class RRD::FileTest < MiniTest::Spec 

    attr_reader :rrd

    before do
      @rrd = RRD::File.new("test/data/test.rrd")
    end

    after do
      @rrd.close if @rrd
    end

#    should "read rrd header" do
     # rrd.header
#    end

    should "read rrd data" do
      #RubyProf.start
      p rrd.data(1).last_row

      #result = RubyProf.stop

      # Print a flat profile to text
      #printer = RubyProf::FlatPrinter.new(result)
      #printer.print(STDOUT)
    end

end