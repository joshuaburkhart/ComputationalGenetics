require_relative 'vcf_regex'
require_relative 'vcf_meta_data'
require_relative 'data_line'
require_relative 'info_line'

class VCFParser
  @vcf_filename
  @info_ary
  @data_ary
  @metadata
  def initialize(vcf_filename)
    @vcf_filename = vcf_filename
    @info_ary = Array.new
    @data_ary = Array.new
    @metadata = VCFMetaData.new
  end

  def parse
    non_variants = Array.new
    File.open(@vcf_filename, 'r') do |vcf_fptr|
      vcf_fptr.each_line do |line|
        if !line.match(VCFRegex::IS_INFO).nil?
          iv = line.match(VCFRegex::INFO_VALS)
          @info_ary << InfoLine.new(iv[:iv_id],iv[:iv_description],iv[:iv_type],iv[:iv_range])
        elsif !line.match(VCFRegex::IS_DATA).nil?
          dv = line.match(VCFRegex::DATA_VALS)
          data_line = DataLine.new(dv[:dv_chrom],dv[:dv_pos],dv[:dv_id],dv[:dv_ref],dv[:dv_alt],dv[:dv_qual],dv[:dv_filter],dv[:dv_info],dv[:dv_format],dv[:dv_samples])
          if data_line.alt_count > 0
            @data_ary << data_line
          else
            non_variants << data_line
          end
        else
          md = line.match(VCFRegex::META_DATA)
          if md
            @metadata.add(md[:md_key],md[:md_value])
          else
            puts "skipping #{line}"
            STDOUT.flush
          end
        end
        print '.'
        STDOUT.flush
      end
      puts
      puts "#{@vcf_filename} parsed."
      nv_rep = "#{non_variants.size} variants matching reference genotype"
      nv_rep << ("\n #{DataLine.header_s}")
      non_variants.each_with_index { |nv,idx |
        nv_rep << "\n" << " Non-variant #{idx + 1}, #{nv}"
      }
      @metadata.add('Non-variants',nv_rep)
    end
  end

  # @return [Array]
  def vcf_info
    @info_ary
  end

  # @return [Array]
  def vcf_data
    @data_ary
  end

  # @return [VCFMetaData]
  def vcf_metadata
    @metadata
  end
end