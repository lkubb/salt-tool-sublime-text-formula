include:
  - .package

# @TODO Linux/Windows
# on MacOS, Homebrew cask automatically links it
{%- if 'Darwin' != grains['kernel'] %}
Sublime Text is available in PATH as subl:
  file.symlink:
    - name: /usr/local/bin/subl
    - target: {{ subltarget }}
    - require:
      - Sublime Text is installed
{%- endif %}
