require 'test/unit'
require 'sass'
require 'sass-globbing'
require 'pry'
require 'open3'

class SassGlobbingTest < Test::Unit::TestCase

  def test_can_import_globbed_files
    css = render_file("all.sass")
    assert_match(/deeply-nested/, css)
    assert_match %r{No files to import found in doesnotexist/\*\\/foo\.\*}, css
  end

  def test_can_import_globbed_files_via_stdin
    sass = File.read(File.expand_path('../fixtures/all.sass', __FILE__))
    sass_dir = File.expand_path('../fixtures', __FILE__)
    css, _, _= Open3.capture3("sass -r sass-globbing", stdin_data: sass, chdir: sass_dir)

    assert_match(/deeply-nested/, css)
    assert_match %r{No files to import found in doesnotexist/\*\\/foo\.\*}, css
  end

private
  def render_file(filename)
    fixtures_dir = File.expand_path("fixtures", File.dirname(__FILE__))
    full_filename = File.expand_path(filename, fixtures_dir)
    syntax = File.extname(full_filename)[1..-1].to_sym
    engine = Sass::Engine.new(File.read(full_filename),
                              :syntax => syntax,
                              :filename => full_filename,
                              :cache => false,
                              :read_cache => false,
                              :load_paths => [fixtures_dir])
    engine.render
  end
end
