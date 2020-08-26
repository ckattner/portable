# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'acts_as_hashable'
require 'benchmark'
require 'csv'
require 'fileutils'
require 'forwardable'
require 'objectable'
require 'realize'
require 'time'

# Shared modules/classes
require_relative 'portable/util'

# Main implementation points
require_relative 'portable/data'
require_relative 'portable/document'
require_relative 'portable/rendering'
require_relative 'portable/writers'
