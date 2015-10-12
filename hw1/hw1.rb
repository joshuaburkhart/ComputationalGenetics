# Usage: ruby hw1.rb infile [outname]

require_relative 'src/lib/vcf_parser'

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

poly_count = data_ary.size
data_ary.sort! {|a,b| a.alt_pct <=> b.alt_pct}
rare_vars = data_ary.first(10)
common_vars = data_ary.last(10)
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
summary_fptr.puts('Common Variants:')
summary_fptr.puts(" #{DataLine.header_s}")
common_vars.reverse.each do |variant|
  summary_fptr.puts(" #{variant}")
end
summary_fptr.puts
summary_fptr.puts('Rare Variants:')
summary_fptr.puts(" #{DataLine.header_s}")
rare_vars.each do |variant|
  summary_fptr.puts(" #{variant}")
end
summary_fptr.puts
summary_fptr.puts 'VCF Metadata:'
summary_fptr.puts(metadata)
summary_fptr.close
puts 'done.'
