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
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
sprintf($dtime, "%02d/%02d/%04d", $mon, $mday, $year);

# print "Class name? ";
$cname   = <STDIN>;
$upCname = uc $cname;

# Construct file contents of the header
$hpp =  
    "/**\\file $cname.$headEXT\n".
    " * \\author \n".
    " * \\date $dtime\n".
    " */\n\n".
    "#ifndef $upCname"."_H_INC\n".
    "#define $upCname"."_H_INC\n".
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
    "/**\\file   $cname.$srcEXT\n".
    " * \\author $author\n".
    " * \\date   $dtime\n".
    " */\n\n".
    "$cname::$cname(){\n}\n\n".
    "$cname::~$cname(){\n}\n\n";

# open(HEADER, "include/$cname.h") or die "Failed to open header for writing";
# open(SRC, "src/$cname.cpp") or die "Failed to open source for writting";
