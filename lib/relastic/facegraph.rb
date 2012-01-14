#the connections are set globally
# type of @nodes: FaceNode
# type of @image: Image
# type of @image_normalized: Image
class FaceGraph
  include EBGM
  attr_accessor :nodes
  attr_reader :image
  attr_reader :image_normalized

  def initialize(image, face_bunch_graph)
    # this is a hash{index => FaceNode}
    @nodes = {}
    @image = Image.new(image)
    # no normalization in ruby
    @image_normalized = @image
    face_bunch_graph.nodes.each do |index, bunch|
      @nodes[index] = FaceNode.new(bunch, @image_normalized, face_bunch_graph.jetmask)
    end
    @nodes.each do |i,node|
      node.neighbours = face_bunch_graph.nodes[i].neighbours.map{|n| @nodes[n.first]}
    end
  end
  def compare_with(other_fg)
    sum = 0.0
    self.nodes.each do |i, node|
      sum += 1 - predictive_step_compare(node.jet,other_fg.nodes[i].jet,0,0)
    end
    p sum
    sum *  self.nodes.count
  end
  def save(name='default')

  end

  # paint the nodes and edges in the normalized image
  def draw
    @nodes.each do |i,node|
      x = node.jet.x
      y = node.jet.y
      node.neighbours.each do |n|
        x2 = n.jet.x
        y2 = n.jet.y
        @image_normalized.draw_line(x,y,x2,y2)
      end
      @image_normalized.draw_point(x,y)
    end
  end
end

# type of @jet: Jet
# contains the best matching jet after comparison and his neighbours
class FaceNode
  attr_reader :jet
  attr_accessor :neighbours

  def initialize(bunch, image, masks)
    @jet = Jet.new(bunch.x_avg, bunch.y_avg, image, masks)
    displacement = @jet.get_best_match_displacement_iterative(bunch)
    @jet.x += displacement[0]
    @jet.y += displacement[1]
    neighbours = []
  end
  def to_s
    "ich bin ein facenode at #{jet.x},#{jet.y}"
  end
end
