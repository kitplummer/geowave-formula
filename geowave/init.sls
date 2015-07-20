{%- from 'hadoop/hdfs/settings.sls' import hdfs with context %}
{%- from 'geowave/settings.sls' import geowave with context %}

#### Set-up Geowave Repo if needed ####
{%- if geowave.from_pkg_repo %}
remove-existing-geowave-repo:
  pkgrepo.absent:
    - name: geowave

geowave-repo:
  pkg.installed:
    - sources:
      - geowave-repo: {{ geowave.repo_pkg_url }}
    - require:
      - pkgrepo: remove-existing-geowave-repo

#### If not using GeoWave Repo, install Core dependency ####
{%- else %}
{{ geowave.core_pkg }}:
  pkg.installed:
#    - version: {{ geowave.geowave_version }}
    - sources:
      - {{ geowave.core_pkg }}: {{ geowave.core_pkg_url }}
{%- endif %}

#### Set-up GeoWave on Accumulo Master ####
{%- if geowave.is_namenode %}
include:
  - sudoers
#  - hadoop
#  - accumulo

#### Fix Hadoop ####
/usr/bin/hadoop:
  file.symlink:
    - target: /usr/lib/hadoop/bin/hadoop

/usr/lib/hadoop/bin/hadoop:
  file.replace:
    - pattern: bin=`\s*dirname \${bin}`
    - repl: bin=`readlink -f ${bin}`;bin=`dirname ${bin}`
    - count: 1
    - flags: ['MULTILINE']

#### Set-up GeoWave on Accumulo Master from Package Repo ####
{%- if geowave.from_pkg_repo %}
{{ geowave.accumulo_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - version: {{ geowave.geowave_version }}
    - require:
      - pkg: geowave-repo
      - file: /usr/bin/hadoop
      - file: /usr/lib/hadoop/bin/hadoop

#### Set-up GeoWave on Accumulo Master from URL ####
{%- else %}
{{ geowave.tools_pkg }}:
  pkg.installed:
    - version: {{ geowave.geowave_version }}
    - sources:
      - {{ geowave.tools_pkg }}: {{ geowave.tools_pkg_url }}
    - require:
      - pkg: {{ geowave.core_pkg }}

{{ geowave.accumulo_pkg }}:
  pkg.installed:
    - version: {{ geowave.geowave_version }}
    - sources:
      - {{ geowave.accumulo_pkg }}: {{ geowave.accumulo_pkg_url }}
    - require:
      - pkg: {{ geowave.core_pkg }}
      - pkg: {{ geowave.tools_pkg }}
      - file: /usr/bin/hadoop
      - file: /usr/lib/hadoop/bin/hadoop
{%- endif %}

geowave-accumulo-config:
  cmd.script:
    - source: salt://geowave/files/geowave-accumulo-config.sh
    - args: {{ hdfs.namenode_host }} {{ geowave.name_node_port }} {{ geowave.accumulo_classpath }} {{ geowave.accumulo_user }} {{geowave.accumulo_pswd }}
    - user: accumulo
    - require:
      - pkg: {{ geowave.accumulo_pkg }}
{%- endif %}

#### Set-up GeoWave on App Server ####
{%- if geowave.is_appserver %}
include:
  - sudoers

#### Set-up GeoWave on App Server from Package Repo ####
{%- if geowave.from_pkg_repo %}
{{ geowave.tools_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - version: {{ geowave.geowave_version }}
    - require:
      - pkg: geowave-repo

{{ geowave.geoserver_pkg }}:
  pkg.installed:
    - fromrepo: geowave
    - version: {{ geowave.geowave_version }}
    - require:
      - pkg: geowave-repo

#### Set-up GeoWave on App Server from URL ####
{%- else %}
{{ geowave.tools_pkg }}:
  pkg.installed:
    - version: {{ geowave.geowave_version }}
    - sources:
      - {{ geowave.tools_pkg }}: {{ geowave.tools_pkg_url }}
    - require:
      - pkg: {{ geowave.core_pkg }}

{{ geowave.geoserver_pkg }}:
  pkg.installed:
    - version: {{ geowave.geowave_version }}
    - sources:
      - {{ geowave.geoserver_pkg }}: {{ geowave.geoserver_pkg_url }}
    - require:
      - pkg: {{ geowave.core_pkg }}
      - pkg: {{ geowave.tools_pkg }}
{%- endif %}
{%- endif %}
