class VCFMetaData
  @data_hash
  def initialize
    @data_hash = Hash.new
  end

  def add(key,value)
    @data_hash[key] = value
  end

  def to_s
    rep = ''
    key_ary = @data_hash.keys.sort
    key_ary.each do |key|
      rep << "#{key}: #{@data_hash[key]}" << "\n"
    end
    rep
  end
end