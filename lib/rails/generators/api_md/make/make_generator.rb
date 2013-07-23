module ApiMd
  module Generators
    class MakeGenerator < Rails::Generators::Base
      desc "Generates API documents from controllers in the rails app from special syntax and stuff NEED EXPLANATION HERE"

      source_root File.expand_path("../templates", __FILE__)

      def clear_all
        puts 'Clearing all old files'
        FileUtils.rm_rf("#{Rails.root.join('api_doc')}/.", secure: true)
      end

      def extract_post_from_routes
        @data ||= []
        all_routes = Rails.application.routes.routes.routes
        all_routes.each do |route|
          if route.verb == /^POST$/
            obj = {}
            obj['controller'] = route.defaults[:controller]
            obj['action'] = route.defaults[:action]
            obj['path'] = Rails.application.routes.url_helpers.url_for(only_path: true, controller: route.defaults[:controller], action: route.defaults[:action])
            @data << obj
          end
        end
        puts "Extracted the data"
      end

      def pull_data_from_controllers
        @final_data ||= []
        @data.each do |d|
          found_def = false
          obj = {}
          controller_path = Rails.root.join('app','controllers',"#{d['controller']}_controller.rb")
          # puts "#{controller_path} exists? #{File.exist?(controller_path)}"
          if File.exist?(controller_path)
            catch(:done) do
              f = File.readlines(controller_path).each do |line|
                regex = /\s#{Regexp.quote(d['action'])}[\s#]*#\)/
                unless found_def
                  if line.scan(regex).length > 0
                    # puts line
                    found_def = true
                    obj['controller'] = "#{d['controller']}"
                    obj['path'] = d['path']
                    obj['description'] = line.split("#)").last.lstrip
                  end
                else
                  if line.scan(/def \S+[\s#]*#/).length > 0
                    throw :done #need to check if this works
                  else
                    # puts line
                    if !line.downcase['params:'].nil?
                      obj['params'] = line.split("params:").last.strip
                      # puts "Params detected"
                    elsif !line.downcase['response:'].nil?
                      obj['response'] = line.split("response:").last.strip
                      # puts "Response detected"
                    else
                      # puts "Nothing detected"
                    end
                  end
                end
              end
            end
            # puts "Object found: #{obj}"
            @final_data << obj if obj.keys.count > 0
          else
            puts "Can't find file - #{controller_path}"
          end
        end
      end

      def write_to_file
        @final_data ||= []
        @final_data.each do |f|
          begin
            @controller = f['controller']
            @filename = f['controller'] + "_controller.md"
            @path = f['path'].strip
            @description = f['description']
            @make_params = false
            @make_response = false

            @params = JSON.parse(f['params']) rescue nil
            if @params
              @params = {"auth_token"=>"AUTHTOKEN","data"=>@params}
              @pretty_params = JSON.pretty_generate(@params).split("\n") rescue nil
              @meta_params = []
              @params.keys.each{ |k| @meta_params << {'param' => k} }
              @make_params = true
            end

            @response = JSON.parse(f['response']) rescue nil
            if @response
              @response = {"data"=>@response,"success"=>"true","errors"=>"nil"} # specific to Appximus input format
              @pretty_response = JSON.pretty_generate(@response).split("\n") rescue nil
              @meta_response = []
              @response.keys.each{ |k| @meta_response << {'param' => k} }
              @make_response = true
            end
            
            unless File.exists?(Rails.root.join('api_doc',@filename))
              template('api_header.md', Rails.root.join('api_doc',@filename))
            end
            template('api_block.md', 'temp.md')
            File.open(Rails.root.join('api_doc',@filename), 'a') do |f|
              f << File.read('temp.md')
            end
            File.delete('temp.md')
          rescue => e
            puts "Failed to create data for: #{f.to_json}"
            puts e.message
          end
        end
      end
    end
  end
end