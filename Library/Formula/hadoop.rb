require 'formula'

class Hadoop < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-1.0.0/hadoop-1.0.0.tar.gz'
  homepage 'http://hadoop.apache.org/common/'
  md5 'fa150612de0efe80be88144c28225780'
  version '1.0.0'
  
  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec #{libexec}/bin/#{target} $@
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin sbin conf lib webapps share docs]
    libexec.install Dir['*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    inreplace "#{libexec}/conf/hadoop-env.sh",
      "# export JAVA_HOME=/usr/lib/j2sdk1.6-sun",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/conf/hadoop-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    EOS
  end
end
