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

info_filename = "#{outname}_INFO_DICT.txt"
summary_filename = "#{outname}_SUMMARY_TXT.txt"

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
g1 = Scruffy::Graph.new
g1.renderer = Scruffy::Renderers::Standard.new
g1.value_formatter = Scruffy::Formatters::Percentage.new(:precision => 0)
g1.add :line, 'Position vs ALT Genotype % Reported', data_ary.collect{|line| line.alt_pct}
g1.render :to => 'pos_v_alt_pct.svg'
g1.render :width => 800,
             :height => 600,
             :to => 'pos_v_alt_pct.svg',
             :as =>'png'
rescue NoMethodError
  puts $!
  #scruffy gem should be updated
end
poly_count = data_ary.size
data_ary.sort! {|a,b| b.alt_pct <=> a.alt_pct}
data_csv_fptr = File.open("#{outname}_SUMMARY_CSV.csv",'w')
  data_csv_fptr.puts DataLine.header_c("\t")
  data_ary.each do |line|
    data_csv_fptr.puts line.to_csv("\t")
end
data_ary.sort! {|a,b| a.alt_pct <=> b.alt_pct}
rare_vars = data_ary.first(100)
common_vars = data_ary.last(100)
cv0  = common_vars.select{|line|line.alt_pct > 0 and line.alt_pct < 10}
cv10 = common_vars.select{|line|line.alt_pct > 10 and line.alt_pct < 20}
cv20 = common_vars.select{|line|line.alt_pct > 20 and line.alt_pct < 30}
cv30 = common_vars.select{|line|line.alt_pct > 30 and line.alt_pct < 40}
cv40 = common_vars.select{|line|line.alt_pct > 40 and line.alt_pct < 50}
cv50 = common_vars.select{|line|line.alt_pct > 50 and line.alt_pct < 60}
cv60 = common_vars.select{|line|line.alt_pct > 60 and line.alt_pct < 70}
cv70 = common_vars.select{|line|line.alt_pct > 70 and line.alt_pct < 80}
cv80 = common_vars.select{|line|line.alt_pct > 80 and line.alt_pct < 90}
cv90 = common_vars.select{|line|line.alt_pct > 90}
cv0val = cv0.nil? ? 1 : cv0.size + 1
cv10val = cv10.nil? ? 1 : cv10.size + 1
cv20val = cv20.nil? ? 1 : cv20.size + 1
cv30val = cv30.nil? ? 1 : cv30.size + 1
cv40val = cv40.nil? ? 1 : cv40.size + 1
cv50val = cv50.nil? ? 1 : cv50.size + 1
cv60val = cv60.nil? ? 1 : cv60.size + 1
cv70val = cv70.nil? ? 1 : cv70.size + 1
cv80val = cv80.nil? ? 1 : cv80.size + 1
cv90val = cv90.nil? ? 1 : cv90.size + 1
begin
  g2 = Scruffy::Graph.new
  g2.renderer = Scruffy::Renderers::Pie.new
  g2.title = 'ALT Genotype % Reported Dist. (Top 100)'
  g2.add :pie, '', {
                    '0-10%' => cv0val,
                    '10-20%' => cv10val,
                    '20-30%' => cv20val,
                    '30-40%' => cv30val,
                    '40-50%' => cv40val,
                    '50-60%' => cv50val,
                    '60-70%' => cv60val,
                    '70-80%' => cv70val,
                    '80-90%' => cv80val,
                    '90-100%' => cv90val
                }

  g2.render :to => 'alt_pct_100_pie.svg'
  g2.render :width => 800, :height => 600,
               :to => 'alt_pct_100_pie.svg', :as => 'png'
rescue NoMethodError
  puts $!
  #scruffy gem should be updated
end
begin
  g3 = Scruffy::Graph.new
  g3.renderer = Scruffy::Renderers::Standard.new
  g3.value_formatter = Scruffy::Formatters::Percentage.new(:precision => 0)
  g3.add :bar, 'ALT Genotype % Reported (Top 100)', data_ary.sort {|a,b| b.alt_pct <=> a.alt_pct}.collect{|line| line.alt_pct}.first(100)
  g3.render :to => 'alt_pct_100_bar.svg'
  g3.render :width => 800,
               :height => 600,
               :to => 'alt_pct_100_bar.svg',
               :as =>'png'
rescue NoMethodError
  puts $!
  #scruffy gem should be updated
end
da0 = data_ary.select{|line|line.alt_pct > 0 and line.alt_pct < 10}
da10 = data_ary.select{|line|line.alt_pct > 10 and line.alt_pct < 20}
da20 = data_ary.select{|line|line.alt_pct > 20 and line.alt_pct < 30}
da30 = data_ary.select{|line|line.alt_pct > 30 and line.alt_pct < 40}
da40 = data_ary.select{|line|line.alt_pct > 40 and line.alt_pct < 50}
da50 = data_ary.select{|line|line.alt_pct > 50 and line.alt_pct < 60}
da60 = data_ary.select{|line|line.alt_pct > 60 and line.alt_pct < 70}
da70 = data_ary.select{|line|line.alt_pct > 70 and line.alt_pct < 80}
da80 = data_ary.select{|line|line.alt_pct > 80 and line.alt_pct < 90}
da90 = data_ary.select{|line|line.alt_pct > 90}
da0val = da0.nil? ? 1 : da0.size + 1
da10val = da10.nil? ? 1 : da10.size + 1
da20val = da20.nil? ? 1 : da20.size + 1
da30val = da30.nil? ? 1 : da30.size + 1
da40val = da40.nil? ? 1 : da40.size + 1
da50val = da50.nil? ? 1 : da50.size + 1
da60val = da60.nil? ? 1 : da60.size + 1
da70val = da70.nil? ? 1 : da70.size + 1
da80val = da80.nil? ? 1 : da80.size + 1
da90val = da90.nil? ? 1 : da90.size + 1
begin
g4 = Scruffy::Graph.new
g4.renderer = Scruffy::Renderers::Pie.new
g4.title = 'ALT Genotype % Reported Dist.'
g4.add :pie, '', {
                  '0-10%' => da0val,
                  '10-20%' => da10val,
                  '20-30%' => da20val,
                  '30-40%' => da30val,
                  '40-50%' => da40val,
                  '50-60%' => da50val,
                  '60-70%' => da60val,
                  '70-80%' => da70val,
                  '80-90%' => da80val,
                  '90-100%' => da90val
              }

g4.render :to => 'alt_pct_pie.svg'
g4.render :width => 800, :height => 600,
             :to => 'alt_pct_pie.svg', :as => 'png'
rescue NoMethodError
  puts $!
  #scruffy gem should be updated
end
metadata = vcf_parser.vcf_metadata
summary_fptr = File.open(summary_filename,'w')
summary_header = "Summary for #{infile}"
summary_fptr.puts summary_header
summary_fptr.puts '='*summary_header.size
summary_fptr.puts
summary_fptr.puts("Polymorphic Site% (Polys/Refs): \
#{format('%.4f',Float(poly_count * 100)/Float(max_data.position - min_data.position))}% \
(#{poly_count}/#{max_data.position - min_data.position})")
summary_fptr.puts("Total Number of Polymorphic Sites in Region: \
#{poly_count}")
summary_fptr.puts("Polymorphic Region: \
#{min_data.chromosome}:#{min_data.position} \
-> #{max_data.chromosome}:#{max_data.position}")
summary_fptr.puts("Polymorphic Region Size: \
#{max_data.position - min_data.position}")
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
