require "opencv"
include OpenCV
include Math
class GaborMask
  attr_reader :wavelength,:orientation,:phase,:aspect_ratio,:sigma,:size,:image,:kx,:ky
  def initialize(w = 4, o = 0,p = PI/4,a = 1.00, s = 3.00,size = 19)
    @wavelength = w
    @orientation = o
    @phase = p
    @aspect_ratio = a
    @sigma = s
    @size = size
    @image = mda(@size,@size)

    makemask
  end

  def mda(width,height)
    a = Array.new(width)
    a.map! { Array.new(height) }
    a
  end

  def makemask
    j=0
    i=0
    size = @size
    theta = @orientation
    lambda = @wavelength
    sigma = @sigma
    phi = @phase
    gamma = @aspect_ratio
    @kx = 2 * PI * cos(theta) / lambda
    @ky = 2 * PI * sin(theta) / lambda
    for j in 0..size-1
      for i in 0..size-1
        x = size/2.0 - size + i
        y = size/2.0 - size + j
        xs = x*cos(theta) +y * sin(theta)
        ys = -x*sin(theta) +y * cos(theta)
        tmp1 = -1.0*(xs*xs + gamma*gamma * ys*ys)/(2.0*sigma*sigma)
        tmp2 = (2.0*PI*xs/lambda)+phi
        @image[i][j] = exp(tmp1)*(cos(tmp2))
      end
    end
  end

  # faltet einen mit x, y gegebenen Bildausschnitt der Matrix anhand des Gabor-Wavelets
  # TODO: Interpolation wenn x,y keine ganzen Zahlen sind
  # TODO: phase wenn gerundet wird noch weiternutzen
  def convolve_point(x, y, image)
    sum = 0
    offsetx = x - @size/2 + 0.5 # x wird in die Mitte des Bildausschnitts gerueckt
    offsety = y - @size/2 + 0.5 # y ebenso

    # iterieren über alle Pixel
    i=0
    j=0
    while(i < @size)
      while(j < @size)
        #if(x = 50 && y = 50)
        #binding.pry
        #end
        sum += image.at(i + offsetx.truncate, j + offsety.truncate).to_i * @image[i][j] # at sollte bei Grauwertbild das richtige liefern
          # bei Interpolation .truncate entfernen
        i+=1
        j+=1
      end
    end
    sum
  end


  def render(name="kernel")
    pic = CvMat.new(@size,@size,0,1)
    pic.set_data self.normalize_image
    pic.save_image("#{name}.png")
  end
  # (wert+1)*128 - 1 für fall -1 -> 1
  # #TODO refactor to not use OpenCv here and Image instead
  def normalize_image
    @new_image = @image.map do |x|
      x.map do |wert|
        if wert < -1
          puts "woot #{wert}"
        end
        ((wert+1)*128 - 1).to_i
      end
    end
    @new_image
  end

end

