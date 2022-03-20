{%- from 'tool-subl/map.jinja' import subl %}

{%- for user in subl.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

Sublime Text configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._subl.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/sublime-text
      - salt://dotconfig/sublime-text
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - makedirs: True
{%- endfor %}
