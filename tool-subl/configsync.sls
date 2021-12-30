{%- from 'tool-subl/map.jinja' import subl %}

{%- for user in subl.users | selectattr('dotconfig') %}
Sublime Text configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._subl.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/sublime-text
      - salt://dotconfig/sublime-text
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
