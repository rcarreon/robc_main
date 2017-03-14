#!/bin/env ruby

require 'facter'

$xm = "/usr/sbin/xm"

# Only run on Xen Masters
if File.exist?("/dev/xen")

  def add_fact(name, value)
    Facter.add(name) do
      setcode do
        value
      end
    end
  end

  virtual_machines = `#{$xm} list | sed '1,2d' | awk '{print $1}'`.split("\n")

  if $?.exitstatus ==  0
    vm_count = virtual_machines.size
    add_fact("domU_count", vm_count)

    virtual_machines.each_index do |index|
      add_fact("domU_#{index}", virtual_machines[index])
    end
  end
end
