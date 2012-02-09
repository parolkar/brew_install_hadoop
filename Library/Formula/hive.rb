require 'formula'

class Hive < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=hive/hive-0.8.1/hive-0.8.1-bin.tar.gz'
  homepage 'http://hive.apache.org'
  md5 '432e77c86f67ae34ec67258d17157191'

  depends_on 'hadoop'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf examples lib scripts]
    libexec.install Dir['*.jar']
    bin.mkpath

    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end

  def caveats; <<-EOS.undent
    Hadoop must be in your path for hive executable to work.
    After installation, set $HIVE_HOME in your profile:
      export HIVE_HOME=#{libexec}

    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    
    Configuration of Hadoop:
      in mapred-site.xml:
      <property>
        <name>mapred.capacity-scheduler.queue.hive.capacity</name>
        <value>70</value>
        <description>Percentage of the number of slots in the cluster that are
        to be available for jobs in this queue.
        </description>
      </property>
    
    EOS
  end
end
