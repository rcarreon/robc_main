#!/usr/bin/env ruby

require 'erb'

class TemplateFile
  attr_accessor :names, :template_path

  def initialize(path, data)
    @template_path = path
    data.each do |arg|
      parts = arg.split('=')
      var_name = "@#{parts[0]}"
      var_value = parts[1]
      self.instance_variable_set(var_name, var_value)
    end 
  end 

  def get_binding
    binding()
  end 
end


path = ARGV.shift
file = TemplateFile.new(path, ARGV)
renderer = ERB.new(File.read(file.template_path))
puts output = renderer.result(file.get_binding)

