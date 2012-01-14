# type of @nodes: Bunch
class FaceBunchGraph
  CPATH = "#{File.dirname(__FILE__)}/../../data/"
  attr_reader :nodes, :jetmask
  def initialize(train_image_path, train_graphs_path)
    file_edges=""
    train_pairs = []
    Dir.foreach("#{train_graphs_path}/") do |entry|
      filename = entry.split("/").last.split(".").first
      file_graph = "#{train_graphs_path}/#{filename}.sfi"
      file_edges = "#{train_graphs_path}/edges.txt"
      file_image = "#{train_image_path}/#{filename}.tif"
      #check if both exist
      if (File.exist?(file_graph) && File.exist?(file_image))
        train_pairs << [file_graph,file_image]
      end
    end

    #create global jetmask
    @jetmask = JetMask.new

    # create all facegraphs
    graphs = train_pairs.map do |pair|
      ModelGraph.new(Image.new(pair[1]), pair[0], @jetmask)
    end

    # nodes is a hash{index => bunch}
    @nodes = {}
    # pair all jets to bunches
    $NODE_NAMES.each do |landmark, index|
      @nodes[index] = Bunch.new
      graphs.each do |facegraph|
        @nodes[index].jets << facegraph.nodes[index].jet
      end
    end

    # calculate the average locations
    @nodes.each do |index ,bunch|
      bunch.calc_avg
    end

    # reading edges.txt to generate the edges for all bunches
    if (File.exist?(file_edges))
      edgesfile = File.open(file_edges)
      #read first line and do loop number of read times
      edgesfile.gets.to_i.times do
        line = edgesfile.gets.split(" ")
        # writing the nodes with the specific index into each others neighbours-list
        @nodes[line[0].to_i].neighbours << [line[1].to_i,@nodes[line[1].to_i]]
        @nodes[line[1].to_i].neighbours << [line[0].to_i,@nodes[line[0].to_i]]
      end
    end

    File.open("fbg.dump","w+") do |f|
      Marshal.dump(self,f)
    end
  end
  def to_s
    #ruby commits suicide if we dont override to_s
    "FaceBunchGraph reporting in!"
  end
  def self.new(train_image_path="#{CPATH}train_normalized_images", train_graphs_path="#{CPATH}train_graphs")
    newobj = ""
    #puts "cache starting"
    if File.exist?("#{CPATH}fbg.dump")
      #puts "cache activated"
      File.open("#{CPATH}fbg.dump") do |f|
        newobj = Marshal.load(f)
      end
      return newobj
    else
      super
    end
  end
end

# a bunch is a collection of jets
# it knows its neighbours
# type of @jets: Jet
# type of @neighbours: Bunch
class Bunch
  attr_accessor :jets, :neighbours
  # these define the average location of all jets in the bunch
  attr_reader :x_avg, :y_avg

  def initialize
    @neighbours = []
    @jets = []
  end

  # calculates the average location of the bunch
  def calc_avg
    x_sum, y_sum = 0, 0
    @jets.each do |jet|
      x_sum += jet.x
      y_sum += jet.y
    end
    @x_avg = x_sum / @jets.count
    @y_avg = y_sum / @jets.count
  end
end
