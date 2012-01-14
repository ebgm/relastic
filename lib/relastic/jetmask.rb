# type of @wavelet_pairs: GaborMask
class JetMask
  attr_accessor :wavelet_pairs
  def initialize(file="#{DATAPATH}GaborMaskBolme.wavelet")
    masks = Array.new
    @wavelet_pairs = Array.new
    i=0
    File.open(file).each_line do |line|
      i = i+1
      next if i == 1
      line = line.split(" ")
      masks << GaborMask.new(line[0].to_f,line[1].to_f,line[2].to_f,line[3].to_f,line[4].to_f,line[5].to_f)
    end
    pairing_to_waveletpairs(masks)
  end
  # imaginaeteil und realteil werden paarweise in arrays abgelegt
  # sind in der .waveletdatei zu erkennen an den alternierenden Phasen immer PI/2
  def pairing_to_waveletpairs(masks)
    (masks.count / 2).times do |i|
      @wavelet_pairs << [masks[i*2],masks[i*2+1]]
    end
  end
  def render
    @masks.each_with_index{|mask,i| mask.render("#{i}-kernel")}
  end
end
