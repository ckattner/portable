# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'byte_order_mark'

module Portable
  module Modeling
    # Defines all the options for an export including static header rows, footer rows, and how
    # to draw the data table.
    class Options
      acts_as_hashable

      attr_reader :byte_order_mark

      def initialize(byte_order_mark: nil)
        @byte_order_mark = ByteOrderMark.resolve(byte_order_mark)

        freeze
      end

      def byte_order_mark?
        !byte_order_mark.nil?
      end
    end
  end
end
