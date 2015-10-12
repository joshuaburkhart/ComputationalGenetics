class InfoLine
  @@csv_header = "ID\tDefinition~Type~Range"
  @id
  @definition
  @type
  @range
  def initialize(id,definition,type,range)
    @id = id
    @definition = definition
    @type = type
    @range = range
  end

  def self.header_s
    @@csv_header.gsub('~'," \| ")
  end

  def to_csv
    "#{@id}:\t#{@definition}~#{@type}~#{@range}"
  end

  def to_s
    to_csv.gsub('~'," \| ")
  end
end