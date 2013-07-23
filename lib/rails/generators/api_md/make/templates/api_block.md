###<%= @path.sub("_","\\_") %> {#<%= @path.sub("/","\\_") %>}

<%= @description %>

- How to use
    1. [[NUMBERED INSTRUCTIONS]]

<% if @make_params %>

#####Request: POST

<% @pretty_params.each do |p| %><%= "    #{p.to_s.rstrip}" %>
<% end %>
         
<% if @meta_params.count > 0 %>                

>|params|Descriptions|Required?|
>|------|------------|:---------:|<% @meta_params.each do |r| %>
>|<%= r['param'] %>|<%= r['description'] rescue '[[DESCRIPTION]]' %>|<%= r['required'] rescue 'N' %>|<% end %>
<% end %>

<% end %>

<% if @make_response %>

#####Response

<% @pretty_response.each do |p| %><%= "    #{p.to_s}" %>
<% end %>

<% if @meta_response.length > 0 %>

>|params|Descriptions|ALWAYS?|
>|------|------------|:---------:|<% @meta_response.each do |r| %>
>|<%= r['param'] %>|<%= r['description'] rescue '[[DESCRIPTION]]' %>|<%= r['always'] rescue 'N' %>|<% end %>
<% end %>

<% end %>


*************************************************************************

