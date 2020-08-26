# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Portable
  module Rendering
    class Column # :nodoc: all
      extend Forwardable

      attr_reader :column, :pipeline

      def_delegators :column, :header

      def_delegators :pipeline, :transform

      def initialize(column, resolver: Objectable.resolver)
        raise ArgumentError, 'column is required' unless column

        @column   = column
        @pipeline = Realize::Pipeline.new(column.transformers, resolver: resolver)

        freeze
      end
    end
  end
end
