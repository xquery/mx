export CLASSPATH=$CLASSPATH:/Users/jfuller/Source/MarkLogic/framework-dist/lib/calabash.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/saxon9he.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/commons-httpclient-3.1.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/commons-codec-1.3.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/commons-logging-1.1.1.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/xcc.jar:/Users/jfuller/Source/MarkLogic/framework-dist/lib/tagsoup-1.2.jar 

java com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/feature/http-accept-chrome8.xml src/test/feature/http-accept-chrome8.xpl
java com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/feature/unknown.xml src/test/feature/unknown-uri-pattern.xpl
java com.xmlcalabash.drivers.Main -isource=conf/test-config.xml -oresult=report/feature-report.html src/test/feature/Z_report.xpl

