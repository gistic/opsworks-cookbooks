name              "gistic_cloudera"
maintainer        "GISTIC"
maintainer_email  "melganainy@gistic.org"
license           "Apache 2.0"
description       "Installs Cloudera Manager's dependencies."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"

depends "java"

recipe "gistic_cloudera::oracle_java", "Installs Oracle Java"