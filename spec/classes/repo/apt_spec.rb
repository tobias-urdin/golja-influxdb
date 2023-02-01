require 'spec_helper'

describe 'influxdb::repo::apt' do
  on_supported_os.each do |os, facts|
    # A little ugly, but we only want to run our tests for Debian based machines.
    next unless facts[:operatingsystem] == 'Debian'

    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default params' do
        let(:_operatingsystem) { facts[:operatingsystem].downcase }

        let(:key) do
          {
            'id'     => '9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E',
            'source' => 'https://repos.influxdata.com/influxdata-archive_compat.key'
          }
        end

        let(:include) do
          {
            'src' => false
          }
        end

        it do
          is_expected.to contain_apt__source('repos.influxdata.com').with(ensure: 'present',
                                                                          location: "https://repos.influxdata.com/#{_operatingsystem}",
                                                                          release: facts[:lsbdistcodename],
                                                                          repos: 'stable',
                                                                          key: key,
                                                                          include: include)
        end

        it { is_expected.to contain_class('influxdb::repo::apt') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
