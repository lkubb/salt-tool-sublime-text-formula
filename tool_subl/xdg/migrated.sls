# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as subl with context %}

include:
  - {{ tplroot }}.package


{#- On MacOS, move the actual config to XDG_CONFIG_HOME and symlink it. On Linux,
    ST puts everything except cache into XDG_CONFIG_HOME #}

{%- if 'Darwin' == grains['kernel'] %}
{%-   for user in subl.users | rejectattr('xdg', 'sameas', false) %}

{%-     set user_default_conf = user.home | path_join(subl.lookup.paths.confdir, subl.lookup.paths.conffile) %}
{%-     set user_xdg_confdir = user.xdg.config | path_join(subl.lookup.paths.xdg_dirname) %}
{%-     set user_xdg_conffile = user_xdg_confdir | path_join(subl.lookup.paths.xdg_conffile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
XDG_CONFIG_HOME exists for Sublime Text for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.config }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    # - require:
    #   - sls: {{ tplroot }}.package
    - onlyif:
      - test -e '{{ user_default_conf }}'

Existing Sublime Text configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user_xdg_conffile }}
    - source: {{ user_default_conf }}
    # do not rename if the source is already a symlink
    - unless:
      - test -L '{{ user_default_conf }}'
    - require:
      - XDG_CONFIG_HOME exists for Sublime Text for user '{{ user.name }}'
    - require_in:
      - Sublime Text setup is completed

Sublime Text has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
    - mode: '0700'
    - require:
      - Existing Sublime Text configuration is migrated for user '{{ user.name }}'
    - require_in:
      - Sublime Text setup is completed

Sublime Text uses XDG_CONFIG_HOME via symlink for user {{ user.name }}:
  file.symlink:
    - name: {{ user_default_conf }}
    - target: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: True
    - force: True # if XDG_CONFIG_HOME/sublime-text exists, it will not be overwritten, but the default User dir will be
    - require:
    #   - sls: {{ tplroot }}.package
      - Sublime Text has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - Sublime Text setup is completed

# nice to have if xdg config is checked into version control
Git ignores unnecessary files in Sublime Text's XDG_CONFIG_HOME for user {{ user.name }}:
  file.managed:
    - name: {{ user_xdg_conffile | path_join('.gitignore') }}
    - contents: |
        .SublimeREPLHistory
        oscrypto-ca-bundle.crt
        Package Control.ca-bundle
        Package Control.ca-certs/
        Package Control.ca-list
        Package Control.cache/
        Package Control.last-run
        Package Control.merged-ca-bundle
        Package Control.system-ca-bundle
        Package Control.user-ca-bundle
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0644'
    - dir_mode: '0700'
    - makedirs: true
    - require:
      - Sublime Text uses XDG_CONFIG_HOME via symlink for user {{ user.name }}
{%-   endfor %}
{%- endif %}
