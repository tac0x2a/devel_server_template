#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

USER="vagrant"

package "tmux"

remote_file "/home/#{USER}/.tmux.conf" do
  owner "#{USER}"
  group "#{USER}"
  source "templates/dot.tmux.conf"
end
