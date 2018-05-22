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
  networkmanager
  network-manager-applet
  siji-git
  ttf-font-awesome
  zathura
  zathura-cb
  zathura-ps
  zathura-djvu
  zathura-pdf-poppler
  htop
  volwheel
  i3lock-color
  alsa-utils
  conky
  pavucontrol
  rofi-git
]

install = ->app{ `trizen -Syu --noconfirm #{app}` }

Dir.glob("#{Dir.home}/#{SOURCE}/.", File::FNM_DOTMATCH).each { |f| FileUtils.cp_r("#{f}", DESTINATION, :verbose => true) }
apps.each &install
