xquery version "1.0-ml";
module namespace my="http://example.org/test";

declare function my:test($text) {
<test>{$text}</test>
};

declare function my:test2($a,$b) {
<test>{fn:concat($a,' ',$b)}</test>
};
