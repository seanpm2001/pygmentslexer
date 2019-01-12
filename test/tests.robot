Stuff before first table is considered comment.
...    and there is no continuing here.

*** Settings ***
...              Error
Documentation    Hyvää päivää    ${var}
Library    XML    arg
Resource   ${foobar}.txt    # comment
Invalid    syntax
testsetup   keyword    argument    ${variable}
Test Teardown   ${keyword}    argument    ${argument}
Metadata    Name    Value

| Force tags  |  regression  | ${var}
| ...         |  more        | tags |
# comment

*** Unknown table ***
Stuff in unrecognized tables is considered comment.
This too    is ${comment}.

*variable
...               error
${VARIABLE}       value
${ASSIGNMENT}=    value
@{LIST}           value 1    ${var}    \${not}    \\${var}    \\\${not}    # comment
...               value # not comment
&{DICT}           Key1=Value1    Key2=Value2    Key${3}=${value3}
INVALID           syntax
${IN} ${VALID}    syntax
${INV} ==         syntax

#| @{VARIABLE} | value 1 | value 2 | value 3
| @{VARIABLE} | value 1 | value 2 | value 3 | # comment | here |
|    @{VARIABLE}    |     value  1     | %{ENV} | value 3
| @{VARIABLE} | ${var${inside}} out} | @{${var${not}} | value 3|
| @{VARIABLE} | @{VARIABLE}[0] | @{VARIABLE}[${i}] | value 3 |


| *** Test Case *** | *** Action *** | *** Argument *** |
Example
    Keyword    arg    arg ${with var}    # comment
    Keyword    arg    arg ${with var}    # comment
    [teardown]    keyword    arg

Example 2    [Documentation]    example
    [ t a g s ]    foo
    Keyword    arg    arg ${with var}    # comment
    ${var} =    keyword
    ${var}    keyword    ${arg}   ${two} vars ${here}    arg   arg    arg
    Trailing spaces                            
    ${v1}    ${v2}    @{v3} =    keyword

...
    Keyword    arg1
    ...    ${arg2}
    ${var} =    Keyword    arg1
    ...    ${arg2}
    ${var} =
    ...    Keyword    arg1
    ...    ${arg2}
    ${var1}    ${var2} =    Keyword    arg1
    ...    ${arg2}
    ${var1}
    ...    ${var2} =
    ...    Keyword    arg1    ${arg2}
    ...    arg3
    ...
    ...    arg4

template
    [Template]    Keyword Here
    args       here
    ${more}    args

| Pipes |
|  | [Documentation] | Also pipe separated format is supported |
|  | Should Be Equal |  | ${EMPTY} |
|  | Should Be Equal |     | ${EMPTY}
| |     Log Many     | |foo | bar| | \| | |zap|
| |     Log Many     | | |

FOR
    FOR    ${x}    IN    foo    bar
        Log    ${x}
    END
    No Operation
    FOR    ${x}    IN    ${1}    two    3
    ...    neljä    ${6} - 1
        Log    ${x}
    END
    FOR    ${i}
    ...    IN RANGE    42
        ${ret} =    Keyword    ${i}
        ...    more    args
    END
    FOR    ${index}    ${item}    IN ENUMERATE    @{STUFF}
        No Operation
    END
    FOR    ${a}    ${b}    ${c}    IN ZIP    ${X}    ${Y}    ${Z}
        No Operation
    END
    Log    ...

Old :FOR
    :FOR    ${x}    IN    foo    bar
    \    Log    ${x}
    No Operation
    :FOR    ${x}    IN    ${1}    two    3
    ...    neljä    ${6} - 1
    \    Log    ${x}
    :: FOR    ${i}
    ...    IN RANGE    42
    \    ${ret} =    Keyword    ${i}
    \    ...    more    args
    :FOR    ${index}    ${item}    IN ENUMERATE    @{STUFF}
    \    No Operation
    :FOR    ${a}    ${b}    ${c}    IN ZIP    ${X}    ${Y}    ${Z}
    \    No Operation
    Log    ...

Invalid FOR
    :FOR    ${x}    in    should    be    upper
    \    No Operation
    No Operation
    :FOR    x    IN    not    variable
    \    No Operation
    No Operation


*** Keywords ***    Heading    # Comment     here

XXX
    [Documentation]    hello
    [Tags]  whatever
    kw    arg
    ${var} =    kw    ${var}
    [Teardown]    keyword    arg1    ${var}
    [Return]    ${var}
    [invalid]   syntax

Given ${variable} handling works out-of-the-box
