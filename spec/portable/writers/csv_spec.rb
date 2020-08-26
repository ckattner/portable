# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'snapshot_helper'
require 'spec_helper'

describe Portable::Writers::Csv do
  let(:dir)      { File.join('tmp', 'spec') }
  let(:filename) { File.join(*dir, "#{SecureRandom.uuid}.csv") }
  let(:document) { nil }
  let(:resolver) { Objectable.resolver(separator: '') }
  let(:time)     { Time.now.utc }

  subject { described_class.new(document, resolver: resolver) }

  describe 'snapshots' do
    snapshots.each do |snapshot|
      let(:document) { snapshot.document }

      specify snapshot.name do
        results = subject.write!(
          filename: filename,
          data_provider: snapshot.data_provider,
          time: time
        )

        actual_files   = results.map { |r| read_binary_file(r.filename) }
        expected_files = read_binary_files(snapshot.expected_filenames('csv')).values

        expect(actual_files).to match_array(expected_files)
      end
    end
  end

  context 'README examples' do
    let(:patients) do
      [
        { first: 'Marky', last: 'Mark', dob: '2000-04-05' },
        { first: 'Frank', last: 'Rizzo', dob: '1930-09-22' }
      ]
    end

    let(:keys) { %i[first last dob] }

    let(:data_provider) do
      Portable::Data::Provider.new(
        data_sources: {
          data_rows: patients,
          keys: keys
        }
      )
    end

    describe 'Getting Started Writing CSV Files' do
      let(:document) { nil }

      it 'renders' do
        writer  = Portable::Writers::Csv.new(document)
        results = writer.write!(filename: filename, data_provider: data_provider)

        expect(results.map(&:filename)).to eq([filename])

        actual_files = results.map { |r| read_binary_file(r.filename) }

        expected_files = [
          <<~CSV
            first,last,dob
            Marky,Mark,2000-04-05
            Frank,Rizzo,1930-09-22
          CSV
        ]

        expect(actual_files).to eq(expected_files)
      end
    end

    describe 'Realize Transformation Pipelines' do
      let(:document) do
        {
          sheets: [
            {
              data_table: {
                auto: false,
                columns: [
                  {
                    header: 'First Name',
                    transformers: [
                      { type: 'r/value/resolve', key: :first }
                    ]
                  },
                  {
                    header: 'Last Name',
                    transformers: [
                      { type: 'r/value/resolve', key: :last }
                    ]
                  },
                  {
                    header: 'Date of Birth',
                    transformers: [
                      { type: 'r/value/resolve', key: :dob },
                      { type: 'r/format/date', output_format: '%m/%d/%Y' },
                    ]
                  }
                ]
              }
            }
          ]
        }
      end

      it 'renders' do
        writer  = Portable::Writers::Csv.new(document)
        results = writer.write!(filename: filename, data_provider: data_provider)

        expect(results.map(&:filename)).to eq([filename])

        actual_files = results.map { |r| read_binary_file(r.filename) }

        expected_files = [
          <<~CSV
            First Name,Last Name,Date of Birth
            Marky,Mark,04/05/2000
            Frank,Rizzo,09/22/1930
          CSV
        ]

        expect(actual_files).to eq(expected_files)
      end
    end

    describe 'Static Header/Footer Rows' do
      let(:data_provider) do
        Portable::Data::Provider.new(
          data_sources: {
            data_rows: patients,
            keys: %i[first last dob],
            header_rows: [
              %w[FIRST_START LAST_START DOB_START]
            ],
            footer_rows: [
              %w[FIRST_END LAST_END DOB_END]
            ]
          }
        )
      end

      let(:document) do
        {
          sheets: [
            {
              header_rows: [
                ['Run Date', '04/05/2000'],
                ['Run By', 'Hops the Bunny'],
                [],
                ['BEGIN']
              ],
              footer_rows: [
                ['END']
              ]
            }
          ]
        }
      end

      it 'renders' do
        writer  = Portable::Writers::Csv.new(document)
        results = writer.write!(filename: filename, data_provider: data_provider)

        expect(results.map(&:filename)).to eq([filename])

        actual_files = results.map { |r| read_binary_file(r.filename) }

        expected_files = [
          <<~CSV
            Run Date,04/05/2000
            Run By,Hops the Bunny

            BEGIN
            FIRST_START,LAST_START,DOB_START
            first,last,dob
            Marky,Mark,2000-04-05
            Frank,Rizzo,1930-09-22
            FIRST_END,LAST_END,DOB_END
            END
          CSV
        ]

        expect(actual_files).to eq(expected_files)
      end
    end
  end
end
