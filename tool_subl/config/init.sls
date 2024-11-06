# vim: ft=sls

{#-
    Manages the Sublime Text package configuration by

    * recursively syncing from a dotfiles repo

    Has a dependency on `tool_subl.package`_.
#}

include:
  - .sync
