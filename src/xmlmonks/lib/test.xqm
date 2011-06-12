xquery version "1.0-ml";
                                              
(: Simple XQuery Unit Test Library - Jim Fuller 05/11/10 :)

module namespace test = "http://www.marklogic.com/test";

(: --------------------------------------------------------------------------------------------------- :)
(:                                                                                      boolean Tests  :)
(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertEqual($a as item()*, $b as item()*) as xs:boolean {
    ($a eq $b)
};


(: --------------------------------------------------------------------------------------------------- :)
(:                                                                                          XML Tests  :)
(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertXMLEqual($a as item()*, $b as item()*) as xs:boolean {
    fn:deep-equal($a,$b)
};
declare function test:assertXMLNotEqual($a as item()*, $b as item()*) as xs:boolean {
    fn:not(test:assertXMLEqual($a,$b))
};

(: --------------------------------------------------------------------------------------------------- :)
(:                                                                                       String Tests  :)
(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertStringEqual($a as xs:string, $b as xs:string) as xs:boolean {  
 fn:not(fn:boolean(fn:compare($a, $b)))
};
declare function test:assertStringNotEqual($a as xs:string, $b as xs:string) as xs:boolean {  
 fn:boolean(fn:compare($a, $b))
};
declare function test:assertStringContain($a as xs:string, $b as xs:string) as xs:boolean {
    fn:contains($a, $b)
};
declare function test:assertStringNotContain($a as xs:string, $b as xs:string) as xs:boolean {
    fn:not(fn:contains($a, $b))
};

(: --------------------------------------------------------------------------------------------------- :)
(:                                                                                      Integer Tests  :)
(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertIntegerEqual($a as xs:integer, $b as xs:integer) as xs:boolean {  
  fn:boolean($a=$b) 
};
declare function test:assertIntegerNotEqual($a as xs:integer, $b as xs:integer) as xs:boolean {  
  fn:not(fn:boolean($a=$b)) 
};


(: --------------------------------------------------------------------------------------------------- :)
(:                                                                                   Eval(evil) Tests  :)
(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertEvalEqual($xpathstring, $expected){
  let $actual := xdmp:eval($xpathstring)
  return 
    test:assertXMLEqual($actual, $expected)
};

