# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'modeling/options'
require_relative 'modeling/sheet'

module Portable
  # Top-level object model for a renderable document.
  class Document
    include Util::Pivotable
    include Util::Uniqueness
    acts_as_hashable

    attr_reader :options

    def initialize(sheets: [], options: {})
      @sheets_by_name = make_unique_sheets_by_name(sheets)
      @options        = Modeling::Options.make(options, nullable: false)

      freeze
    end

    def sheet(name)
      sheets_by_name.fetch(name.to_s)
    end

    def sheets
      sheets_by_name.values
    end

    private

    attr_reader :sheets_by_name

    def make_unique_sheets_by_name(sheets)
      sheets = Modeling::Sheet.array(sheets)
      sheets << Modeling::Sheet.new if sheets.empty?

      assert_no_duplicate_names(sheets)
      pivot_by_name(sheets)
    end
  end
end
