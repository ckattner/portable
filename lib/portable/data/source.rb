# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Portable
  module Data
    # A single source of data.  This is meant to serve as an interface / example implementation
    # with the intention of being re-implemented within applications.  For example, you may
    # decide more database data sources would be better, so it could be connected to ORMs or
    # other data adapters; all it really needs to provide is enumerables for each attribute.
    class Source
      acts_as_hashable

      attr_reader :header_rows,
                  :footer_rows,
                  :data_rows,
                  :keys,
                  :name

      # Individial header and footer rows are arrays, while individual data_rows is an object
      # like a hash, Struct, OpenStruct, or really any PORO.
      def initialize(name: '', header_rows: [], footer_rows: [], data_rows: [], keys: [])
        @name        = name.to_s
        @header_rows = header_rows || []
        @footer_rows = footer_rows || []
        @data_rows   = data_rows   || []
        @keys        = keys        || []

        freeze
      end
    end
  end
end
