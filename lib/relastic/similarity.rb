module EBGM
  include Math
  def predictive_iter(jet1,jet2)
    ret = dx = dy = 0
    3.times do 
      ret,(dx,dy) = predictive_step(jet1,jet2,dx,dy)
      #puts ret,dx,dy
    end
    [ret,[dx,dy]]
    
  end
  def predictive_step(jet1,jet2,dx=0,dy=0)

    gxx = gxy = gyx = gyy = px = py = 0.0

    jet1.polar_coords.count.times do |i|
      kx = jet1.jetmask.wavelet_pairs[i][1].kx
      ky = jet1.jetmask.wavelet_pairs[i][1].ky

      ang = jet1.polar_coords[i][1] - jet2.polar_coords[i][1] - ( dx * kx + dy * ky)
      ang -= 2*PI while ang > PI 
      ang += 2*PI while ang < -PI 
      
      magmulti = jet1.polar_coords[i][0] * jet2.polar_coords[i][0] 

      # g.. is the sum Gamma
      gxx += magmulti * kx * kx 
      gyx += magmulti * ky * kx 
      gxy += magmulti * ky * kx 
      gyy += magmulti * ky * ky 

      # p. is the sum phi
     px += magmulti * kx * ang
     py += magmulti * ky * ang
    end

    dx +=  (gyy*px - gyx*py) / (gxx*gyy - gxy*gyx)
    dy +=  (-gxy*px + gxx*py) / (gxx*gyy - gxy*gyx)
    sim = predictive_step_compare(jet1,jet2,dx,dy)

    [sim,[dx,dy]]
    
  end
  def predictive_step_compare(jet1,jet2,dx,dy) 
    #TODO check if jets are the same size
    sum12 = 0
    sum1_square = 0
    sum2_square = 0
    jet1.polar_coords.each_with_index do | coord, index |
      sum12 += coord[0]*jet2.polar_coords[index][0] * Math::cos(coord[1] - jet2.polar_coords[index][1] - (dx * jet1.jetmask.wavelet_pairs[index][1].kx + dy * jet1.jetmask.wavelet_pairs[index][1].ky ))
      sum1_square += coord[0]**2
      sum2_square += jet2.polar_coords[index][0]**2
    end
    sum12/Math::sqrt(sum1_square*sum2_square)
  end
  #def compare_jet_magnitude other_jet
    #sum12 = 0
    #sum1_square = 0
    #sum2_square = 0
    #@polar_coords.each_with_index do | coord, index |
      #sum12 += coord[0]*other_jet.polar_coords[index][0]
      #sum1_square += coord[0]**2
      #sum2_square += other_jet.polar_coords[index][0]**2
    #end
    #sum12/Math::sqrt(sum1_square*sum2_square)
  #end
  #def compare_jet_phase other_jet
    #sum12 = 0
    #sum1_square = 0
    #sum2_square = 0
    #@polar_coords.each_with_index do | coord, index |
      #sum12 += coord[0]*other_jet.polar_coords[index][0] * Math::cos(coord[1] - other_jet.polar_coords[index][1])
      #sum1_square += coord[0]**2
      #sum2_square += other_jet.polar_coords[index][0]**2
    #end
    #sum12/Math::sqrt(sum1_square*sum2_square)
  #end
end
