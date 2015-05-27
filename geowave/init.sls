{%- from 'geowave/settings.sls' import geowave with context %}

remove-existing-geowave-repo:
  pkgrepo.absent:
    - name: geowave

#geowave-repo:
#  pkgrepo.managed:
#    - humanname: geowave
#    - name: geowave
#    - baseurl: {{ geowave.repo_pkg_url }}

geowave-repo:
  pkg.installed:
    - sources:
      - geowave-repo: {{ geowave.repo_pkg_url }}

{%- if geowave.is_namenode %}
{{ geowave.accumulo_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - require:
#      - pkgrepo: geowave-repo
      - pkg: geowave-repo
{%- endif %}

{%- if geowave.is_appserver %}
{{ geowave.geoserver_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - require:
      - pkg: geowave-repo

{{ geowave.tools_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - require:
      - pkg: geowave-repo
{%- endif %}