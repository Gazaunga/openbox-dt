#!/usr/bin/env ruby

require 'fileutils'

SOURCE = "#{Dir.home}/openbox-dt"

DESTINATION = "#{Dir.home}/"

apps = %w[
  openbox 
  tint2-git 
  compton-git 
  vlc
  ranger 
  mpd 
  ncmpcpp 
  rxvt-unicode-pixbuf 
  dunst 
  obmenu-generator 
  sxhkd-git 
  ob-autostart 
  obkey 
  latex-mk 
  j4-dmenu-desktop 
  networkmanager-git 
  siji-git 
  ttf-font-awesome-4 
  zathura-git 
  zathura-cb-git 
  zathura-ps-git 
  zathura-djvu-git 
  zathura-pdf-poppler-git
]

install = ->app{ `trizen -Syu --noconfirm --ignore="inxi" #{app}` }

Dir.glob("#{Dir.home}/#{SOURCE}/.", File::FNM_DOTMATCH).each { |f| FileUtils.cp_r("#{f}", DESTINATION, :verbose => true) }
apps.each &install
