# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'yaml'

def read_binary_files(filenames)
  filenames.each_with_object({}) do |filename, memo|
    expected_filename = File.basename(filename)

    memo[expected_filename] = read_binary_file(*filename)
  end
end

def read_yaml_file(*filename)
  YAML.safe_load(read_binary_file(*filename))
end

def read_binary_file(*filename)
  File.open(File.join(*filename), 'rb').read
end
