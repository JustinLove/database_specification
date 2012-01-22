require 'database_specification'

describe DatabaseSpecification do
  let(:ar_sqlite) do
    {
      :adapter => 'sqlite3',
      :database => 'db/development.sqlite3',
      :pool => 5,
      :timeout => 5000,
    }
  end
  let(:sequel_sqlite) do
    {
      :adapter => 'sqlite',
      :database => 'db/development.sqlite3',
      :pool => 5,
      :timeout => 5000,
    }
  end
  let(:url_sqlite) {'sqlite://db/development.sqlite3?pool=5&timeout=5000'}
  let(:url_sqlite_bare) {'sqlite://db/development.sqlite3'}
  let(:ar_postgres) do
    {
      :adapter => 'postgresql',
      :database => 'pacha_development',
      :username => 'user',
      :password => 'pass',
      :host => 'localhost',
      :port => 1111,
    }
  end
  let(:ar_postgres_short) do
    {
      :adapter => 'postgresql',
      :database => 'pacha_development',
    }
  end
  let(:url_postgres_short) {'postgres://localhost/pacha_development'}
  let(:sequel_postgres) do
    {
      :adapter => 'postgres',
      :database => 'pacha_development',
      :user => 'user',
      :password => 'pass',
      :host => 'localhost',
      :port => 1111,
    }
  end
  let(:url_postgres) {'postgres://user:pass@localhost:1111/pacha_development'}

  describe 'ActiveRecord' do
    describe 'sqlite' do
      subject {DatabaseSpecification.active_record(ar_sqlite)}
      its(:active_record) {should == ar_sqlite}
      its(:sequel) {should == sequel_sqlite}
      its(:url) {should == url_sqlite}
      its(:url_bare) {should == url_sqlite_bare}
    end
    describe 'postgres' do
      subject {DatabaseSpecification.active_record(ar_postgres)}
      its(:active_record) {should == ar_postgres}
      its(:sequel) {should == sequel_postgres}
      its(:url) {should == url_postgres}
    end
    describe 'postgres short' do
      subject {DatabaseSpecification.active_record(ar_postgres_short)}
      its(:url) {should == url_postgres_short}
    end
  end
  describe 'Sequel' do
    describe 'sqlite' do
      subject {DatabaseSpecification.sequel(sequel_sqlite)}
      its(:active_record) {should == ar_sqlite}
      its(:sequel) {should == sequel_sqlite}
      its(:url) {should == url_sqlite}
    end
    describe 'postgres' do
      subject {DatabaseSpecification.sequel(sequel_postgres)}
      its(:active_record) {should == ar_postgres}
      its(:sequel) {should == sequel_postgres}
      its(:url) {should == url_postgres}
    end
  end
  describe 'url' do
    describe 'sqlite' do
      subject {DatabaseSpecification.url(url_sqlite)}
      its(:active_record) {should == ar_sqlite}
      its(:sequel) {should == sequel_sqlite}
      its(:url) {should == url_sqlite}
    end
    describe 'postgres' do
      subject {DatabaseSpecification.url(url_postgres)}
      its(:active_record) {should == ar_postgres}
      its(:sequel) {should == sequel_postgres}
      its(:url) {should == url_postgres}
    end
  end
end
