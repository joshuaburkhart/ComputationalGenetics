require_relative 'vcf_regex'

class DataLine
  @@csv_header = 'Chrom:Pos~ID~Ref->Alt~Variant%~Variants/Samples'
  @chrom
  @pos
  @id
  @ref
  @alt
  @qual
  @filter
  @info
  @format
  @samples
  @sample_count
  @alt_count
  @alt_pct
  def initialize(chrom,pos,id,ref,alt,qual,filter,info,format,samples)
    @chrom        = chrom
    @pos          = pos
    @id           = id
    @ref          = ref
    @alt          = alt
    @qual         = qual
    @filter       = filter
    @info         = info
    @format       = format
    @samples      = samples
    @sample_count = samples.scan(VCFRegex::GT_CALL).size
    @alt_count    = samples.scan(VCFRegex::ALT_GT).size
    @alt_pct      = Float(alt_count*100)/Float(sample_count)
  end

  def self.header_s
    @@csv_header.gsub('~',' ')
  end

  def sample_count
    @sample_count
  end

  def alt_count
    @alt_count
  end

  def alt_pct
    @alt_pct
  end

  def id
    @id
  end

  # @return [Integer]
  def position
    Integer(@pos)
  end

  # @return [String]
  def chromosome
    @chrom
  end

  def to_csv
    "#{@chrom}:#{@pos}~#{@id}~#{@ref}->#{@alt}~#{format('%.4f',alt_pct)}%~(#{alt_count}/#{sample_count})"
  end

  def to_s
    to_csv.gsub('~',' ')
  end
end