# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'file_helper'

class Snapshot
  DOCUMENT_FILENAME      = 'document.yaml'
  DATA_PROVIDER_FILENAME = 'data_provider.yaml'

  attr_reader :document,
              :data_provider,
              :name,
              :path

  def initialize(path)
    @path          = path
    @name          = File.basename(path)
    @document      = read_document
    @data_provider = Portable::Data::Provider.make(read_data_provider, nullable: false)

    freeze
  end

  def expected_filenames(folder)
    expected_files_path = File.join(*path, folder, '*')

    Dir[expected_files_path]
  end

  private

  def read_document
    read_yaml_file(path, DOCUMENT_FILENAME)
  end

  def read_data_provider
    read_yaml_file(path, DATA_PROVIDER_FILENAME)
  end

  def read_snapshot_yaml_file(*filename)
    read_yaml_file(SNAPSHOT_PATH, *filename)
  end
end

def snapshots
  snapshot_paths.map { |path| Snapshot.new(path) }
end

def snapshot_paths
  Dir[File.join('spec', 'fixtures', 'snapshots', '*')]
end
