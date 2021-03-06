# library module: http://www.marklogic.com/test


## Table of Contents

* Functions: [assertExists\#1](#func_assertExists_1), [assertEqual\#2](#func_assertEqual_2), [assertXMLEqual\#2](#func_assertXMLEqual_2), [assertXMLNotEqual\#2](#func_assertXMLNotEqual_2), [assertStringEqual\#2](#func_assertStringEqual_2), [assertStringNotEqual\#2](#func_assertStringNotEqual_2), [assertStringContain\#2](#func_assertStringContain_2), [assertStringNotContain\#2](#func_assertStringNotContain_2), [assertIntegerEqual\#2](#func_assertIntegerEqual_2), [assertIntegerNotEqual\#2](#func_assertIntegerNotEqual_2), [assertEvalEqual\#2](#func_assertEvalEqual_2), [test\#2](#func_test_2)


## Functions

### <a name="func_assertExists_1"/> assertExists\#1
```xquery
assertExists($a as item()*
) as  xs:boolean
```

#### Params

* a as  item()\*


#### Returns
*  xs:boolean

### <a name="func_assertEqual_2"/> assertEqual\#2
```xquery
assertEqual($a as item()*, $b as item()*
) as  xs:boolean
```

#### Params

* a as  item()\*

* b as  item()\*


#### Returns
*  xs:boolean

### <a name="func_assertXMLEqual_2"/> assertXMLEqual\#2
```xquery
assertXMLEqual($a as item()*, $b as item()*
) as  xs:boolean
```

#### Params

* a as  item()\*

* b as  item()\*


#### Returns
*  xs:boolean

### <a name="func_assertXMLNotEqual_2"/> assertXMLNotEqual\#2
```xquery
assertXMLNotEqual($a as item()*, $b as item()*
) as  xs:boolean
```

#### Params

* a as  item()\*

* b as  item()\*


#### Returns
*  xs:boolean

### <a name="func_assertStringEqual_2"/> assertStringEqual\#2
```xquery
assertStringEqual($a as xs:string, $b as xs:string
) as  xs:boolean
```

#### Params

* a as  xs:string

* b as  xs:string


#### Returns
*  xs:boolean

### <a name="func_assertStringNotEqual_2"/> assertStringNotEqual\#2
```xquery
assertStringNotEqual($a as xs:string, $b as xs:string
) as  xs:boolean
```

#### Params

* a as  xs:string

* b as  xs:string


#### Returns
*  xs:boolean

### <a name="func_assertStringContain_2"/> assertStringContain\#2
```xquery
assertStringContain($a as xs:string, $b as xs:string
) as  xs:boolean
```

#### Params

* a as  xs:string

* b as  xs:string


#### Returns
*  xs:boolean

### <a name="func_assertStringNotContain_2"/> assertStringNotContain\#2
```xquery
assertStringNotContain($a as xs:string, $b as xs:string
) as  xs:boolean
```

#### Params

* a as  xs:string

* b as  xs:string


#### Returns
*  xs:boolean

### <a name="func_assertIntegerEqual_2"/> assertIntegerEqual\#2
```xquery
assertIntegerEqual($a as xs:integer, $b as xs:integer
) as  xs:boolean
```

#### Params

* a as  xs:integer

* b as  xs:integer


#### Returns
*  xs:boolean

### <a name="func_assertIntegerNotEqual_2"/> assertIntegerNotEqual\#2
```xquery
assertIntegerNotEqual($a as xs:integer, $b as xs:integer
) as  xs:boolean
```

#### Params

* a as  xs:integer

* b as  xs:integer


#### Returns
*  xs:boolean

### <a name="func_assertEvalEqual_2"/> assertEvalEqual\#2
```xquery
assertEvalEqual($xpathstring, $expected
)
```

#### Params

* xpathstring as 

* expected as 


### <a name="func_test_2"/> test\#2
```xquery
test($message as xs:string?, $result as xs:boolean
) as  xs:string
```

#### Params

* message as  xs:string?

* result as  xs:boolean


#### Returns
*  xs:string





*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
