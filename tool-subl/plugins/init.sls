{%- from 'tool-subl/map.jinja' import subl -%}

# @TODO install dependencies for plugins as well
# need to figure out which python and path sublime uses
# or just rely on virtualenvs / direnv / asdf
# I had this with states for several plugins, but
# just using pip.installed is generally not enough

# I tried it with file.serialize option merge_if_exists and json serializer,
# but it does not merge nested lists. Furthermore, the
# file is supposed to be valid JSON, but has trailing commas. Tried
# parsing the file as yaml and dumping it with serializer_opts:
# default_flow_style: True and default_style: '"' (and canonical: False) (which might produce valid json).
# But it does not merge lists. Therefore, I had to write my own wrappers using json5 lib. Yay.

{%- for user in subl.users %}
  {%- for plugin in user.subl.plugins %}
Sublime Package Control makes sure {{ plugin }} is installed for user {{ user.name }}:
  subl.pkg_installed:
    - name: {{ plugin }}
    - user: {{ user.name }}
  {%- endfor %}
{%- endfor %}
