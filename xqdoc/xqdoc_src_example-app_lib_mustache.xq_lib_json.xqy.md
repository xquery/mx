# library module: http://marklogic.com/json


## Table of Contents

* Variables: [$jsonBits](#var_jsonBits), [$keyObjectStack](#var_keyObjectStack), [$typeStack](#var_typeStack)
* Functions: [jsonToXML\#1](#func_jsonToXML_1), [jsonToXML\#2](#func_jsonToXML_2), [dispatch\#1](#func_dispatch_1), [startObject\#1](#func_startObject_1), [endObject\#1](#func_endObject_1), [startObjectKey\#1](#func_startObjectKey_1), [endObjectKey\#0](#func_endObjectKey_0), [buildObjectValue\#1](#func_buildObjectValue_1), [startArray\#1](#func_startArray_1), [endArray\#1](#func_endArray_1), [startArrayItem\#1](#func_startArrayItem_1), [endArrayItem\#0](#func_endArrayItem_0), [getType\#1](#func_getType_1), [typeToElement\#2](#func_typeToElement_2), [readCharsUntil\#2](#func_readCharsUntil_2), [readCharsUntilNot\#2](#func_readCharsUntilNot_2), [xmlToJson\#1](#func_xmlToJson_1), [processElement\#1](#func_processElement_1), [outputObject\#1](#func_outputObject_1), [outputArray\#1](#func_outputArray_1), [escape\#1](#func_escape_1)


## Variables

### <a name="var_jsonBits"/> $jsonBits
```xquery
$jsonBits as  xs:string\*
```

### <a name="var_keyObjectStack"/> $keyObjectStack
```xquery
$keyObjectStack as  xs:string\*
```

### <a name="var_typeStack"/> $typeStack
```xquery
$typeStack as  xs:string\*
```



## Functions

### <a name="func_jsonToXML_1"/> jsonToXML\#1
```xquery
jsonToXML($json
)
```

#### Params

* json as 


### <a name="func_jsonToXML_2"/> jsonToXML\#2
```xquery
jsonToXML(
    $json as xs:string,
    $asXML as xs:boolean
)
```

#### Params

* json as  xs:string

* asXML as  xs:boolean


### <a name="func_dispatch_1"/> dispatch\#1
```xquery
dispatch(
    $location as xs:integer
) as   xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*   xs:string\*

### <a name="func_startObject_1"/> startObject\#1
```xquery
startObject(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_endObject_1"/> endObject\#1
```xquery
endObject(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_startObjectKey_1"/> startObjectKey\#1
```xquery
startObjectKey(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_endObjectKey_0"/> endObjectKey\#0
```xquery
endObjectKey(
) as  xs:string*
```

#### Returns
*  xs:string\*

### <a name="func_buildObjectValue_1"/> buildObjectValue\#1
```xquery
buildObjectValue(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_startArray_1"/> startArray\#1
```xquery
startArray(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_endArray_1"/> endArray\#1
```xquery
endArray(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_startArrayItem_1"/> startArrayItem\#1
```xquery
startArrayItem(
    $location as xs:integer
) as  xs:string*
```

#### Params

* location as  xs:integer


#### Returns
*  xs:string\*

### <a name="func_endArrayItem_0"/> endArrayItem\#0
```xquery
endArrayItem(
) as  xs:string*
```

#### Returns
*  xs:string\*

### <a name="func_getType_1"/> getType\#1
```xquery
getType(
    $location as xs:integer
)
```

#### Params

* location as  xs:integer


### <a name="func_typeToElement_2"/> typeToElement\#2
```xquery
typeToElement(
    $elementName as xs:string,
    $type as xs:string
) as  xs:string
```

#### Params

* elementName as  xs:string

* type as  xs:string


#### Returns
*  xs:string

### <a name="func_readCharsUntil_2"/> readCharsUntil\#2
```xquery
readCharsUntil(
    $location as xs:integer,
    $stopChars as xs:string+
)
```

#### Params

* location as  xs:integer

* stopChars as  xs:string+


### <a name="func_readCharsUntilNot_2"/> readCharsUntilNot\#2
```xquery
readCharsUntilNot(
    $location as xs:integer,
    $ignoreChar as xs:string
) as  xs:integer
```

#### Params

* location as  xs:integer

* ignoreChar as  xs:string


#### Returns
*  xs:integer

### <a name="func_xmlToJson_1"/> xmlToJson\#1
```xquery
xmlToJson(
    $element as element()
) as  xs:string
```

#### Params

* element as  element()


#### Returns
*  xs:string

### <a name="func_processElement_1"/> processElement\#1
```xquery
processElement(
    $element as element()
) as  xs:string
```

#### Params

* element as  element()


#### Returns
*  xs:string

### <a name="func_outputObject_1"/> outputObject\#1
```xquery
outputObject(
    $element as element()
) as  xs:string
```

#### Params

* element as  element()


#### Returns
*  xs:string

### <a name="func_outputArray_1"/> outputArray\#1
```xquery
outputArray(
    $element as element()
) as  xs:string
```

#### Params

* element as  element()


#### Returns
*  xs:string

### <a name="func_escape_1"/> escape\#1
```xquery
escape(
    $string as xs:string
) as  xs:string
```

#### Params

* string as  xs:string


#### Returns
*  xs:string





*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
