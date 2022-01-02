{%- from 'tool-subl/map.jinja' import subl -%}

include:
  - .package
{%- if 'Darwin' != grains['kernel'] %}
 - .cli
{%- elif subl.users | rejectattr("xdg", "sameas", False) %}
  - .xdg
{%- endif %}
{%- if subl.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
