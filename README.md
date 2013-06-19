api_md
======

A ruby gem that pulls comments from rails controller to generate markdown document  

A simple gem for a simple (yet specific) task.  The gem will go through the route file in Rails, pull out all POST routes, and traverse controller files looking for matching controller (assuming they follow Rails convention).  If those controllers have relevent comments around the function, then they will be extracted, and a markdown document will be generated for that section.

Currently only supports my own personal markdowns, POST requests and my own template.  An example is shown below:

~~~~~~~~~
def location_name #) Get location name from LocID 
#) params: {"LocID":1}
#) response: {"Name":"LocationName"}
  @location = Salesloc.where(LocID: @data['LocID']).first

  if @location
    render_response(@location.Name, true, nil)
  else
    render_response(nil, false, "Can not find location with id=#{@data['id']}")
  end
end
~~~~~~~~~

If a "#)" appears on a line with "def" and the target action's name, then such markdowns will be generated.  The gem will then read through each line until the next "def" or end of file.  Before it ends its iteration, the gem will pick up any line with "#)", and check whether it contains "params" or "response", which will be used to generate the MD sections.  All files generated will then be compiled into an MD file (per controller) and placed in the "RAILS_ROOT/api_doc" folder.

This is not even close to any real development, and in no way intended to be used in any kind of environment. 