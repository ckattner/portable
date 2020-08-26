# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'data_table'

module Portable
  module Modeling
    # Abstract concept modeling for the notion of a "sheet" in a "document".  This means different
    # things given the writer.  For example, all writers should support multiple sheets but
    # there is no internal representation of a "sheet" within a CSV, so each sheet will emit
    # one file.
    class Sheet
      acts_as_hashable
      extend Forwardable

      def_delegators :data_table,
                     :auto?,
                     :columns,
                     :include_headers?

      attr_reader :data_source_name,
                  :data_table,
                  :footer_rows,
                  :header_rows,
                  :name

      def initialize(
        data_source_name: '',
        data_table: nil,
        footer_rows: [],
        header_rows: [],
        name: ''
      )
        @data_source_name = decide_data_source_name(data_source_name, name)
        @name             = name.to_s
        @data_table       = DataTable.make(data_table, nullable: false)
        @footer_rows      = footer_rows || []
        @header_rows      = header_rows || []

        freeze
      end

      private

      # Use exact name if possible, if not then use the sheet name or else use the
      # "default" one (noted by a blank name).
      def decide_data_source_name(data_source_name, sheet_name)
        if !data_source_name.to_s.empty?
          data_source_name.to_s
        elsif !sheet_name.to_s.empty?
          sheet_name.to_s
        else
          ''
        end
      end
    end
  end
end
