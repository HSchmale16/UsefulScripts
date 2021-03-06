#!/usr/bin/perl
# Prepares a class of that name with a default ctor with seperate
# declaration and implemenation. With a doxyen documentation block at
# top of each file.
#
# Note: This script does not update your makefile. You need to do that
#       yourself.
#
# Henry J Schmale
# April 27, 2015

# ==========================================================
# Config
# ==========================================================
$headDir = "include/";  # Directory to place class headers in
$srcDir  = "src/";      # Directory to place class source in
$headEXT = ".h";        # header file extension
$srcEXT  = ".cpp";      # src file extension
# ==========================================================

# Get author and date information
$author = `git config user.name`;
$myd = `date +%m/%d/%Y`;

print "Class name? ";
# fix strings
$cname   = <STDIN>;
$cname   =~ s/\n//g;
$upCname = uc $cname;
$author  =~ s/\n//g;
$myd     =~ s/\n//g;

# Construct file contents of the header
$hpp =  
    "/**\\file $cname$headEXT\n".
    " * \\author $author\n".
    " * \\date $myd\n".
    " */\n\n".
    "#ifndef $upCname"."_H_INC\n".
    "#define $upCname"."_H_INC\n\n".
    "class $cname"."{\n".
    "public:\n".
    "    $cname"."();\n".
    "    ~$cname"."();\n".
    "protected:\n".
    "private:\n".
    "};\n".
    "#endif // $upCname"."_H_INC";

# Construct the cpp file contents
$cpp =
    "/**\\file   $cname$srcEXT\n".
    " * \\author $author\n".
    " * \\date   $myd\n".
    " */\n\n".
    "#include \"../include/$cname$headEXT\"\n\n".
    "$cname"."::"."$cname(){\n}\n\n".
    "$cname"."::~"."$cname(){\n}\n\n";

# write out to file
open(HEAD_FILE, ">$headDir$cname$headEXT") or die "Couldn't open header file for writing: $!";
open(SRC_FILE, ">$srcDir$cname$srcEXT") or die "Couldn't open source file for writing: $!";
print HEAD_FILE "$hpp";
print SRC_FILE "$cpp";
close HEAD_FILE;
close SRC_FILE;
