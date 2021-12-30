{%- from 'tool-subl/map.jinja' import subl -%}

include:
  - .package
#  - .cli
{%- if 'Darwin' == grains['kernel'] && subl.users | rejectattr("xdg", "sameas", False) %}
  - .xdg
{%- endif %}
