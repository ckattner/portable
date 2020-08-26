# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'
require_relative 'result'

module Portable
  module Writers
    # Can write documents to a CSV file.
    class Csv < Base
      def write!(filename:, data_provider: Data::Provider.new, time: Time.now.utc)
        raise ArgumentError, 'filename is required' if filename.to_s.empty?

        ensure_directory_exists(filename)

        sheet_filenames = extrapolate_filenames(filename, document.sheets.length)

        document.sheets.map.with_index do |sheet, index|
          data_source    = data_provider.data_source(sheet.data_source_name)
          sheet_filename = sheet_filenames[index]

          time_in_seconds = Benchmark.measure do
            write_sheet(sheet_filename, sheet, data_source, time)
          end.real

          Result.new(sheet_filename, time_in_seconds)
        end
      end

      private

      def write_sheet(sheet_filename, sheet, data_source, time)
        CSV.open(sheet_filename, 'w') do |csv|
          csv.to_io.write(document.options.byte_order_mark) if document.options.byte_order_mark?

          write_head(csv, sheet, data_source)
          write_data_table(csv, sheet, data_source, time)
          write_foot(csv, sheet, data_source)
        end
      end

      def write_head(csv, sheet, data_source)
        sheet.header_rows.each { |row| csv << row }

        data_source.header_rows.each { |row| csv << row }
      end

      def write_data_table(csv, sheet, data_source, time)
        row_renderer = sheet_renderer.row_renderer(sheet.name, data_source.keys)

        csv << row_renderer.headers if sheet.include_headers?

        data_source.data_rows.each do |row|
          csv << row_renderer.render(row, time)
        end
      end

      def write_foot(csv, sheet, data_source)
        data_source.footer_rows.each { |row| csv << row }

        sheet.footer_rows.each { |row| csv << row }
      end

      def extrapolate_filenames(filename, count)
        dir      = File.dirname(filename)
        ext      = File.extname(filename)
        basename = File.basename(filename, ext)

        (0..count).map do |index|
          if index.positive?
            File.join(dir, "#{basename}.#{index}#{ext}")
          else
            filename
          end
        end
      end
    end
  end
end
