{%- from 'tool-sublime-text/map.jinja' import subl -%}

include:
  - .package

{%- if 'Darwin' == grains['kernel'] %}
  {%- for user in subl.users | rejectattr("xdg", "sameas", False) %}
Sublime Text's user directory is moved to XDG_CONFIG_HOME for user '{{ user.name }}:
  file.rename:
    - name: {{ user._subl.confdir }}
    - source: {{ user._subl.default_path }}/Packages/User
    - makedirs: True
    - require:
      - sls: .package
    - unless:
      - test -L '{{ user._subl.default_path }}/Packages/User'

Git ignores unnecessary files in Sublime Text's XDG_CONFIG_HOME for user {{ user.name }}:
  file.managed:
    - name: {{ user._subl.confdir }}/.gitignore
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
    - mode: '0644'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - require:
      - sls: .package

Sublime Text uses XDG_CONFIG_HOME via symlink for user {{ user.name }}:
  file.symlink:
    - name: {{ user._subl.default_path }}/Packages/User
    - target: {{ user._subl.confdir }}
    - makedirs: True
    - force: True # if XDG_CONFIG_HOME/sublime-text exists, it will not be overwritten, but the default User dir will be
    - require:
      - sls: .package
  {%- endfor %}
{%- endif %}