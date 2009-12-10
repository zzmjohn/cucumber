# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    describe Table do
      before do
        @table = Table.new([
          %w{ one  four  seven  },
          %w{ 4444 55555 666666 }
        ], 1)
      end
      
      it "should have the raw table" do
        # @table.cells_rows[0].map{|cell| cell.value}.should == %w{one four seven}
        @table.raw[0].should == %w{one four seven}
      end

      it "should have columns" do
        @table.columns[1].should == %w{four 55555}
      end

      it "should have headers" do
        @table.headers.should == %w{one four seven}
      end
      
      it "should be convertible to an array of hashes" do
        @table.hashes.should == [
          {'one' => '4444', 'four' => '55555', 'seven' => '666666'}
        ]
      end
      
      it "should accept symbols as keys for the hashes" do
        @table.hashes.first[:one].should == '4444'
      end
    end
  end
end