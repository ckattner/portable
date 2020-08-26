# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'column'

module Portable
  module Rendering
    # Internal intermediary class that knows how to combine columns specification
    # instances with their respective Realize pipelines.
    class Row # :nodoc: all
      attr_reader :columns, :resolver

      def initialize(columns, resolver: Objectable.resolver)
        @resolver = resolver
        @columns  = columns.map { |column| Column.new(column, resolver: resolver) }

        freeze
      end

      def render(object, time)
        columns.map { |column| column.transform(object, time) }
      end

      def headers
        columns.map(&:header)
      end

      def model_columns
        columns.map(&:column)
      end

      def merge(other)
        self.class.new(model_columns + other.model_columns, resolver: resolver)
      end
    end
  end
end
