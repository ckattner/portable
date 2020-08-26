# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'row'

module Portable
  module Rendering
    # Understands the connection between a document's sheets and the internal row renderer
    # necessary to render each sheet's data table.
    class Sheet # :nodoc: all
      attr_reader :document, :resolver

      def initialize(document, resolver: Objectable.resolver)
        @document = Document.make(document, nullable: false)
        @resolver = resolver

        @row_renderers = @document.sheets.each_with_object({}) do |sheet, memo|
          memo[sheet.name] = Row.new(sheet.columns, resolver: resolver)
        end

        freeze
      end

      def row_renderer(sheet_name, keys)
        sheet        = document.sheet(sheet_name)
        row_renderer = row_renderers.fetch(sheet_name.to_s)

        return row_renderer unless sheet.auto?

        dynamic_row_renderer(keys).merge(row_renderer)
      end

      private

      attr_reader :row_renderers

      def fields_to_columns(keys)
        key_objects = (keys || []).map { |f| { header: f.to_s } }
        Modeling::Column.array(key_objects)
      end

      def dynamic_row_renderer(keys)
        Row.new(fields_to_columns(keys), resolver: resolver)
      end
    end
  end
end
