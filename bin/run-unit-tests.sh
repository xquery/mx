export CLASSPATH=$CLASSPATH:/Users/jfuller/Source/MarkLogic/framework-dist/lib/calabash.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/saxon9he.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/commons-httpclient-3.1.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/commons-codec-1.3.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/commons-logging-1.1.1.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/xcc.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/tagsoup-1.2.jar 

java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/invoke-module.xml src/test/unit/invoke-module.xpl
java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/const.xml src/test/unit/const.xpl
java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/rewrite.xml src/test/unit/rewrite.xpl
java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/request.xml src/test/unit/request.xpl
java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/misc.xml src/test/unit/misc.xpl
java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/module.xml src/test/unit/module.xpl
java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit/template.xml src/test/unit/template.xpl

java -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/unit-report.html src/test/unit/Z_report.xpl


