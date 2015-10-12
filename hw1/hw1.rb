# Usage: ruby hw1.rb infile [outname]

require_relative 'src/lib/vcf_parser'
require 'mini_magick'
require 'scruffy'
require 'scruffy/rasterizers/mini_magick_rasterizer'

infile = nil
outname = nil
if ARGV.size >= 1 and ARGV.size < 3
  infile = ARGV[0]
  if not File.exist?(infile)
    puts 'real file plz'
    exit
  end
else
  puts 'file plz'
  exit
end

if ARGV.size == 2
  outname = ARGV[1]
else
  outname = infile
end

info_filename = "#{outname}_info.txt"
summary_filename = "#{outname}_summary.txt"

vcf_parser = VCFParser.new(infile)
vcf_parser.parse

info_ary = vcf_parser.vcf_info
info_fptr = File.open(info_filename,'w')
info_fptr.puts InfoLine.header_s
info_fptr.puts
info_ary.each do |info|
  info_fptr.puts info
end
info_fptr.close

data_ary = vcf_parser.vcf_data
data_ary.sort! {|a,b| a.position <=> b.position}
min_data = data_ary.first
max_data = data_ary.last
begin
graph = Scruffy::Graph.new
graph.renderer = Scruffy::Renderers::Standard.new
graph.value_formatter = Scruffy::Formatters::Percentage.new(:precision => 0)
graph.add :line, 'Variant Position vs Alternate %', data_ary.collect{|line| line.alt_pct}
graph.render :to => 'variant_pos_v_alt_pct.svg'
graph.render :width => 800,
             :height => 600,
             :to => 'variant_pos_v_alt_pct.svg',
             :as =>'png'
rescue NoMethodError
  puts $!
  #scruffy gem sucks, has crappy docs, and should be updated
end
poly_count = data_ary.size
data_ary.sort! {|a,b| a.alt_pct <=> b.alt_pct}
rare_vars = data_ary.first(100)
common_vars = data_ary.last(100)
begin
  graph = Scruffy::Graph.new
  graph.renderer = Scruffy::Renderers::Standard.new
  graph.value_formatter = Scruffy::Formatters::Percentage.new(:precision => 0)
  graph.add :bar, 'Variant Alternate % Top 100', data_ary.sort {|a,b| b.alt_pct <=> a.alt_pct}.collect{|line| line.alt_pct}.first(100)
  graph.render :to => 'variant_alt_pct_100.svg'
  graph.render :width => 800,
               :height => 600,
               :to => 'variant_alt_pct_100.svg',
               :as =>'png'
rescue NoMethodError
  puts $!
  #scruffy gem sucks, has crappy docs, and should be updated
end
metadata = vcf_parser.vcf_metadata
summary_fptr = File.open(summary_filename,'w')
summary_header = "Summary for #{infile}"
summary_fptr.puts summary_header
summary_fptr.puts '='*summary_header.size
summary_fptr.puts
summary_fptr.puts("Polymorphic Region: Chromosome \
#{min_data.chromosome}:#{min_data.position} \
-> Chromosome #{max_data.chromosome}:#{max_data.position}")
summary_fptr.puts("Polymorphic Region Size: \
#{max_data.position - min_data.position}")
summary_fptr.puts("Total Number of Polymorphic Sites in Region: \
#{poly_count}")
summary_fptr.puts("Polymorphic Site% (Polys/Refs): \
#{format('%.4f',Float(poly_count * 100)/Float(max_data.position - min_data.position))}% \
(#{poly_count}/#{max_data.position - min_data.position})")
summary_fptr.puts
summary_fptr.puts('100 Most Common Variants:')
summary_fptr.puts(" #{DataLine.header_s}")
common_vars.reverse.each do |variant|
  summary_fptr.puts(" #{variant}")
end
summary_fptr.puts
summary_fptr.puts('100 Rarest Variants:')
summary_fptr.puts(" #{DataLine.header_s}")
rare_vars.each do |variant|
  summary_fptr.puts(" #{variant}")
end
summary_fptr.puts
summary_fptr.puts 'VCF Metadata:'
summary_fptr.puts(metadata)
summary_fptr.close
puts 'done.'
