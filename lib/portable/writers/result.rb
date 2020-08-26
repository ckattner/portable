# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Portable
  module Writers
    # Result return object from a Writer#write! call.
    class Result
      attr_reader :filename, :time_in_seconds

      def initialize(filename, time_in_seconds)
        @filename        = filename
        @time_in_seconds = time_in_seconds

        freeze
      end
    end
  end
end
