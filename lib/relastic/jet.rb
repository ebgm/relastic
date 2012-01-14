include EBGM
class Jet
  attr_accessor :polar_coords, :x, :y
  attr_reader :jetmask
  # berechnet aus:
  # bild
  # x,y koord
  # jetmask
  #
  # ==== die polarkoordinaten der faltungsstärke in amplitude und phase
  def initialize(x,y,image,jetmasks)
    @jetmask = jetmasks
    @complex_coords = convolve_all_jetmasks(x,y,image)
    @polar_coords = compute_polar
    @x = x
    @y = y
  end
  #compute the polar values for all jetmask pairs
  def compute_polar
    @complex_coords.map do |pair|
      r = pair[0]
      i = pair[1]
      magnitude = Math::sqrt(r**2 + i**2)
      phase = if(r != 0)
        if(r>0)
          Math::atan(i / r)
        else
          Math::PI + Math::atan(i / r)
        end
      else
        if(i >= 0)
          Math::PI / 2
        else
          -Math::PI / 2
        end
      end
      [magnitude,phase]
    end
  end
  #call each convolves
  def convolve_all_jetmasks(x,y,image)
    ret = @jetmask.wavelet_pairs.map do |pair|
      real = pair[0].convolve_point(x,y,image)
      imaginary = pair[1].convolve_point(x,y,image)
      [real,imaginary]
    end
  end
  # compares this jet to all jets in the bunch using the compare function in the block
  def get_best_match(bunch)
    best_similarity = -1
    best_displacement = [0,0]
    bunch.jets.each do |next_jet|
      similarity,displacement = yield(next_jet)
      if similarity > best_similarity
        best_displacement = displacement
        best_similarity = similarity
      end
    end
    best_displacement
  end

  def get_best_match_displacement(bunch)
    get_best_match(bunch) {|jet| predictive_step(self,jet)}
  end
  def get_best_match_displacement_iterative(bunch)
    get_best_match(bunch) {|jet| predictive_iter(self,jet)}
  end

  # calls the compare function for magnitudes only
  #def get_best_match_magnitude(bunch)
    #get_best_match(bunch) {|jet| compare_jet_magnitude(jet)}
  #end

  #def get_best_match_phase(bunch)
    #get_best_match(bunch) {|jet| compare_jet_phase(jet)}
  #end
end
