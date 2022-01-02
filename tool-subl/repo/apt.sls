Ensure Sublime Text repository can be managed:
  pkg.installed:
    - pkgs:
      - apt-transport-https # needs to support https repositories
{%- if 'Debian' == grains['os_family'] %}
      - python-apt
{%- endif %}

Sublime Text stable repository is available:
  pkgrepo.managed:
    - humanname: Sublime Text
    - name: deb https://download.sublimetext.com/ apt/stable/
    - key_url: https://download.sublimetext.com/sublimehq-pub.gpg
    - file: /etc/apt/sources.list.d/sublime-text.list
