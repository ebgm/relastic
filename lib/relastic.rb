bla = __FILE__
DATAPATH = "#{File.dirname(bla)}/../../data/"

%w(similarity facebunch facegraph gabormask image jetmask jet modelgraph nodenames).each do |lib|
  require "relastic/#{lib}.rb"
end
