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
    module Uniqueness
      class DuplicateNameError < StandardError; end

      def assert_no_duplicate_names(array)
        names = array.map { |a| a.name.downcase }

        return if names.uniq.length == array.length

        raise DuplicateNameError, "cannot contain duplicate names (case insensitive): #{names}"
      end
    end
  end
end
