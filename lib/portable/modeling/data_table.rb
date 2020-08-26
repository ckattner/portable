# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'column'

module Portable
  module Modeling
    # Defines all the options for the data grid within an export like columns, whether or not
    # you want to include headers, and more.
    class DataTable
      acts_as_hashable

      attr_reader :auto, :columns, :include_headers

      alias include_headers? include_headers
      alias auto? auto

      def initialize(auto: true, columns: [], include_headers: true)
        @auto            = auto || false
        @columns         = Column.array(columns)
        @include_headers = include_headers || false

        freeze
      end
    end
  end
end
