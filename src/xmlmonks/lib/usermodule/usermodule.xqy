xquery version "1.0-ml";

module namespace usermodule = "http://www.marklogic.com/usermodule";

declare default element namespace "http://www.marklogic.com/usermodule";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:output "method = xml";
declare option xdmp:output "omit-xml-declaration = yes";

(: ------------------------------ CONSTANTS ----------------------------------------------- :)

(: LOG LEVELS 0=NO LOGGING, 1=ACCESS METHODS, 2=ALL :)
declare variable $usermodule:LOG_LEVEL as xs:int := 1;

(: ------------------------------ ACCESS ----------------------------------------------- :)


declare function usermodule:check-access($allowed_groups as xs:string*) as xs:boolean 
{
    if(usermodule:check-login ()) then 
        if(usermodule:check-groups($allowed_groups)) then
            let $log := usermodule:log(1, fn:concat("usermodule:check-access - success - username: ",xdmp:get-session-field("user")," groups: ",$allowed_groups))
            return 
                true()
        else
            let $log := usermodule:log(1, fn:concat("usermodule:check-access - missing group - username: ",xdmp:get-session-field("user")," groups: ",$allowed_groups))
            return 
                false()
    else
        let $log := usermodule:log(1, fn:concat("usermodule:check-access - not logged in - username: ",xdmp:get-session-field("user")," groups: ",$allowed_groups))
        return 
            false()
};

declare function usermodule:check-groups($allowed_groups as xs:string*) as xs:boolean 
{
    let $groups := usermodule:user-groups(xdmp:get-session-field("user"))
    return
        some $allowed_group in $allowed_groups
        satisfies not(empty($groups[//name = $allowed_group]))
};


declare function usermodule:check-login ()
    as xs:boolean
{
        if (fn:empty(xdmp:get-session-field("user"))) then
            let $log := usermodule:log(1, fn:concat("usermodule:check-login - not logged in - username: ",xdmp:get-session-field("user")))
            return 
                false()
        else
            let $log := usermodule:log(1, fn:concat("usermodule:check-login - success - username: ",xdmp:get-session-field("user")))
            return 
                true()
};

declare function usermodule:login ($username as xs:string, $password as xs:string)
    as xs:boolean
{
    if (usermodule:get-user($username)/password = xdmp:crypt($password, $username)) then
        let $log := usermodule:log(1, fn:concat("usermodule:login - success - username: ",$username))
        let $login := xdmp:set-session-field("user", $username)
        return
            true()
    else
        let $log := usermodule:log(1, fn:concat("usermodule:login - wrong password - username: ",$username))
        let $login := xdmp:set-session-field("user", ())
        return
            false()
};

declare function usermodule:logout ($username as xs:string)
    as empty-sequence() 
{
    let $log := usermodule:log(1, fn:concat("usermodule:logout username: ",xdmp:get-session-field("user")))
    return 
        xdmp:set-session-field("user", ())
};

(: ------------------------------ USER ----------------------------------------------- :)

declare function usermodule:create-user (
    $username as xs:string,
    $password as xs:string) as empty-sequence()
{
    let $uri := usermodule:user-uri($username)
    return 
        usermodule:create-user-xml(
            $username, 
            <usermodule:user xmlns:usermodule="http://www.marklogic.com/usermodule">
            <usermodule:username>{$username}</usermodule:username>
            <usermodule:password>{xdmp:crypt($password,$username)}</usermodule:password>
            <usermodule:groups/>
            </usermodule:user>
            )
};

declare function usermodule:create-user-details (
    $username as xs:string,
    $password as xs:string,
    $firstname as xs:string,
    $lastname as xs:string,
    $email as xs:string,
    $comment as xs:string) as empty-sequence() 
{
    let $uri := usermodule:user-uri($username)
    let $pw := xdmp:crypt($password,$username)
    return 
        usermodule:create-user-xml(
            $username, 
            <usermodule:user xmlns:usermodule="http://www.marklogic.com/usermodule"
            	href="/users/{data($username)}">
            <usermodule:username>{$username}</usermodule:username>
            <usermodule:password>{$pw}</usermodule:password>
            <usermodule:firstname>{$firstname}</usermodule:firstname>
            <usermodule:lastname>{$lastname}</usermodule:lastname>
            <usermodule:email>{$email}</usermodule:email>
            <usermodule:comment>{$comment}</usermodule:comment>
            <usermodule:groups/>
            </usermodule:user>
            )
};

declare function usermodule:create-user-xml (
    $username as xs:string,
    $user_xml as node()) as empty-sequence()
{
    let $uri := usermodule:user-uri($username)
    return
        xdmp:document-insert(
            $uri, 
            $user_xml,
            xdmp:document-get-permissions($uri),
            xdmp:document-get-collections($uri),
            xdmp:document-get-quality($uri)
            )
};

declare function usermodule:update-user (
    $username as xs:string,
    $user_xml as node()) as empty-sequence()
{
    let $uri := usermodule:user-uri($username)
    return
        for $node in $user_xml/*
        let $target := doc($uri)/system/user/*[local-name() = local-name($node)]
        return
            if($target) then
                xdmp:node-replace($target, $node)
            else
                xdmp:node-insert-child(doc($uri)/user, $node)
};

declare function usermodule:replace-user (
    $username as xs:string,
    $user_xml as node()) as empty-sequence()
{
    let $uri := usermodule:user-uri($username)
    return
        let $target := doc($uri)/user
        return
            if($target) then
                xdmp:node-replace($target, $user_xml)
            else
                usermodule:create-user-xml ($username, $user_xml)
};

declare function usermodule:remove-user (
    $username as xs:string) as empty-sequence()
{
        if ($username) then
            try{
               xdmp:document-delete(usermodule:user-uri($username))
            }catch($e){
                usermodule:log(2, concat($e, " usermodule:remove-user - username: ",$username))
            }
        else 
            ()
};

declare function usermodule:user-uri($username as xs:string) as xs:string {
    concat('/system/user/',encode-for-uri($username))
};

declare function usermodule:list-all-users() as element(users)* {
    usermodule:list-users(())
};

declare function usermodule:list-users($username as xs:string?) as element(users)* {
    let $log := usermodule:log(2, concat("usermodule:list-users - username: ",$username))
    let $users := 
        if(empty($username) or $username = "") then
            doc()/user
        else
            doc(usermodule:user-uri($username))/user
    return
        <usermodule:users>
            {
            for $doc in $users
                return 
                <usermodule:user href="{base-uri($doc)}">
                    {$doc/node()}
                </usermodule:user>
            }
        </usermodule:users>
};

declare function usermodule:get-user($username as xs:string) as element(user)* {
    let $user := doc(usermodule:user-uri($username))
    return
        <usermodule:user href="{base-uri($user)}">
            {$user/user/node()}
        </usermodule:user>
};

(: ------------------------------ GROUPS ----------------------------------------------- :)


declare function usermodule:group-uri($group_name as xs:string) as xs:string {
    concat('/system/group/',encode-for-uri($group_name))
};

declare function usermodule:user-groups($username as xs:string) as element(groups)* 
{
    let $user := usermodule:get-user($username)
    let $log := usermodule:log(2, concat("usermodule:user-groups - username: ",$username," groups:", string($user/groups)))
    return
        <usermodule:groups>
        {
        for $group_name in $user/groups/group
            let $group := doc(usermodule:group-uri($group_name))/group
            return
                <usermodule:group href="{base-uri($group)}">
                    {$group/node()}
                </usermodule:group>
         }
         </usermodule:groups>
};

declare function usermodule:create-group($group_name as xs:string){
    let $uri := usermodule:group-uri($group_name)
    return
        xdmp:document-insert(
            $uri, 
            <usermodule:group>
            <usermodule:name>{$group_name}</usermodule:name>
            </usermodule:group>,
            xdmp:document-get-permissions($uri),
            xdmp:document-get-collections($uri),
            xdmp:document-get-quality($uri))
};

declare function usermodule:update-group (
    $group_name as xs:string,
    $group_xml as node()) as empty-sequence()
{
    let $uri := usermodule:group-uri($group_name)
    return
        for $node in $group_xml/*
        let $target := doc($uri)/system/group/*[name() = name($node)]
        return
            if($target) then
                xdmp:node-replace($target, $node)
            else
                xdmp:node-insert-child(doc($uri)/system/group, $node)
};

declare function usermodule:remove-group (
    $group_name as xs:string)
{
    try{
         xdmp:document-delete(usermodule:group-uri($group_name))
    }catch($e){
        usermodule:log(2, concat($e, " usermodule:remove-group - group_name: ",$group_name))
    }
};

declare function usermodule:user-add-group($username as xs:string, $group_name as xs:string) {
     xdmp:node-insert-child(
        doc(usermodule:user-uri($username))/user/groups, 
        <usermodule:group>{$group_name}</usermodule:group>
     )
};

declare function usermodule:user-remove-group($username as xs:string, $group_name as xs:string) {
     xdmp:node-delete(
        doc(usermodule:user-uri($username))/user/groups/group[text() = $group_name]
     )
};

declare function usermodule:list-all-groups() as element(groups)* {
    usermodule:list-groups(())
};

declare function usermodule:list-groups($group_name as xs:string?) as element(groups)* {
    let $log := usermodule:log(2, concat("usermodule:list-groups - group_name: ",$group_name))
    let $groups := 
        if(empty($group_name) or $group_name = "") then
            doc()/group
        else
            doc(usermodule:group-uri($group_name))
    return
        <usermodule:groups>
            {
            for $doc in $groups
                return 
                <usermodule:group href="{base-uri($doc)}">
                    {$doc/node()}
                </usermodule:group>
            }
        </usermodule:groups>
};

(: ------------------------------ UTIL ----------------------------------------------- :)

declare function usermodule:log($lvl as xs:int, $message as xs:string) {
    if($usermodule:LOG_LEVEL >= $lvl) then xdmp:log($message) else ()
};
