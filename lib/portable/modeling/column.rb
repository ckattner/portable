# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Portable
  module Modeling
    # Defines all the options a column can contain.  The most basic would to just include a header
    # (defaults to '').  If no transformers are defined then a simple resolver using the header
    # will be used.  This works well for pass-through file writes.  Use the transformers to further
    # customize each data point being written.
    class Column
      acts_as_hashable

      DEFAULT_TRANSFORMER_TYPE = 'r/value/resolve'

      attr_reader :header, :transformers

      def initialize(header: '', transformers: [])
        @header       = header.to_s
        @transformers = Realize::Transformers.array(transformers)

        @transformers << default_transformer if @transformers.empty?

        freeze
      end

      private

      def default_transformer
        Realize::Transformers.make(type: DEFAULT_TRANSFORMER_TYPE, key: header)
      end
    end
  end
end
