{%- from 'tool-subl/map.jinja' import subl -%}

# @TODO this is only implemented for MacOS, for Linux, see
# https://www.sublimetext.com/docs/linux_repositories.html
Sublime Text is installed:
  pkg.installed:
    - name: homebrew/cask/sublime-text

{%- for user in subl.users %}
Package Control is also installed for user {{ user.name }} (to make Sublime whole again):
  file.managed:
    - name: {{ user._subl.default_path }}/Installed Packages/Package Control.sublime-package
    - source:
      - salt://tool-subl/files/Package Control.sublime-package
      - https://packagecontrol.io/Package%20Control.sublime-package
    - source_hash: 817937144c34c84c88cd43b85318b2656f9c3fac02f8f72cbc18360b2c26d139 # was at the time of writing, might change
    - makedirs: True
    - mode: '0644'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - require:
      - Sublime Text is installed
{%- endfor %}
