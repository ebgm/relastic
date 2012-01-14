require "opencv"
include OpenCV

class Image
  attr_reader :matrix
  def initialize(file)
    @file = file.to_s
    @img = IplImage.load(file, CV_LOAD_IMAGE_GRAYSCALE)
    @colorimg = IplImage.load file
    @matrix = @img.to_CvMat
  end
  def draw_point(x=10,y=10)
    @colorimg.circle!(CvPoint.new(x,y),1,:color => CvScalar::Red,:thickness => 1)
  end
  def draw_line(x1,y1,x2,y2)
    @colorimg.line!(CvPoint.new(x1,y1),CvPoint.new(x2,y2),:color => CvScalar::Blue)
  end
  def show
    GUI::Window.new("#{@file}").show @colorimg
    GUI::wait_key
  end
  def save(name="output.png")
    @colorimg.save_image(name)
  end
  def at(x,y)
    #only access existing coordinates else return 0
    if(x < 0 || y < 0 || x >= @matrix.size.width || y >= @matrix.size.height )
      return 0
    end
    # OpenCV function
    @matrix.at(x,y)[0]
  end
end
