# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Portable
  module Util # :nodoc: all
    # Mixes in helpers for asserting uniqueness across collections
    module Pivotable
      def pivot_by_name(array)
        array.each_with_object({}) { |object, memo| memo[object.name] = object }
      end
    end
  end
end
