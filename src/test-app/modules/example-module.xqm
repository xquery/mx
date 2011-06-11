xquery version "1.0-ml";
module namespace my="my-namespace-uri";

declare function my:test($text) {
<test>{$text}</test>
};
