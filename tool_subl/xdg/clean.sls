# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}


{%- if grains.kernel == "Darwin" %}
{%-   for user in subl.users | rejectattr("xdg", "sameas", false) %}

{%-     set user_default_conf = user.home | path_join(subl.lookup.paths.confdir, subl.lookup.paths.conffile) %}
{%-     set user_xdg_confdir = user.xdg.config | path_join(subl.lookup.paths.xdg_dirname) %}
{%-     set user_xdg_conffile = user_xdg_confdir | path_join(subl.lookup.paths.xdg_conffile) %}

Check if the default directory is a symlink:
  cmd.run:
    - name: test -L '{{ user_default_conf }}'

Sublime Text configuration lives inside Library for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ user_xdg_conffile }}
    # overwrite the symlink
    - force: true
    - require:
      - Check if the default directory is a symlink

Sublime Text does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_conffile }}
    - require:
      - Sublime Text configuration lives inside Library for user '{{ user.name }}'
{%-   endfor %}
{%- endif %}
