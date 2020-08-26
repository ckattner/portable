# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Portable::Data::Provider do
  specify 'duplicate data source names raise DuplicateNameError' do
    config = {
      data_sources: [
        { name: :sheet1 },
        { name: :sheet1 }
      ]
    }

    expect { described_class.make(config) }.to raise_error(described_class::DuplicateNameError)
  end
end
