# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Portable
  module Writers
    # Abstract base for all writers to share.
    class Base
      attr_reader :document,
                  :sheet_renderer

      def initialize(document, resolver: Objectable.resolver)
        @document       = Document.make(document, nullable: false)
        @sheet_renderer = Rendering::Sheet.new(@document, resolver: resolver)

        freeze
      end

      private

      def ensure_directory_exists(filename)
        path = File.dirname(filename)

        FileUtils.mkdir_p(path) unless File.exist?(path)
      end
    end
  end
end
