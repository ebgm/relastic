# type of @nodes: ModelNode
class ModelGraph
  attr_reader :nodes

  def initialize(image, file, jetmask)
    # this is a hash{index => node}
    @nodes = {}
    modelfile = File.open(file)
    #read first line and do loop number of read times
    modelfile.gets.to_i.times do
      line = modelfile.gets.split(" ")
      @nodes[$NODE_NAMES[line[0]]] = ModelNode.new(line[1].to_f, line[2].to_f, image, jetmask)
    end
  end
end

# type of @jet: Jet
class ModelNode
  attr_reader :x,:y,:jet

  def initialize(x,y, image, jetmask)
    @x = x
    @y = y
    @jet = Jet.new(x,y,image,jetmask)
  end

  def to_s
    "Im a Node at #{@x},#{@y}"
  end
end
