#!/usr/bin/perl
# Prepares a class of that name with a default ctor with seperate
# declaration and implemenation
#
# Henry J Schmale
# April 27, 2015

print "Class name? ";
$cname   = <STDIN>;
$upCname = uc $cname;

# Construct file contents
$hpp =  "/**\\file $cname.h\n".
        " * \\author \n".
        " */\n\n".
        "#ifndef $upCname"."_H_INC\n".
        "#define $upCname"."_H_INC\n".
        "class $cname"."{\n".
        "public:\n".
        "    $cname""();\n".
        "protected:\n".
        "private:\n".
        "};\n".
        "#endif // $upCname"."_H_INC";

# open(HEADER, "include/$cname.h") or die "Failed to open header for writing";
# open(SRC, "src/$cname.cpp") or die "Failed to open source for writting";

