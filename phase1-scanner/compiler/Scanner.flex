import java.io.*;
import  java.io.IOException;
%%
%public
%class Lexer
%unicode
%standalone

%{
    StringBuffer out = new StringBuffer();
    StringBuilder string = new StringBuilder();

%}

%eof{

    //System.out.println(out.toString());

%eof}

LineBreak = (\n|\r|\r\n)
NoneBreakChar = [^\n\r]
WhiteSpace = \s

//Comments
OneLineComment = ("//"{NoneBreakChar}* {LineBreak}?)
MultiLineComment="/*"~"*/"
Comment = {OneLineComment}|{MultiLineComment}


//Digits
Digit= [0-9]
HexDigit=[a-f A-F 0-9]

//Numbers
HexNumber = ("0x"|"0X") {HexDigit}+
FloatNumber = {Digit}+ "." + {Digit}*
ExpoFloatNumber = {FloatNumber}("E"|"e")("-"|"+")?{Digit}+

//Literals
IntLiteral = ({Digit}+) | {HexNumber}
DoubleLiteral = {FloatNumber}|{ExpoFloatNumber}
BooleanLiteral = "false"|"true"


//id
Identifier = [a-zA-Z][a-zA-Z0-9_]*

//States
%state STRING
%%

<YYINITIAL>{
    "__func__"           {out.append("__func__\n");}
    "__line__"           {out.append("__line__\n");}
    "bool"               {out.append("bool\n");}
    "break"              {out.append("break\n");}
    "btoi"               {out.append("btoi\n");}
    "class"              {out.append("class\n");}
    "continue"           {out.append("continue\n");}
    "double"             {out.append("double\n");}
    "dtoi"               {out.append("dtoi\n");}
    "else"               {out.append("else\n");}
    "for"                {out.append("for\n");}
    "if"                 {out.append("if\n");}
    "import"             {out.append("import\n");}
    "int"                {out.append("int\n");}
    "itob"               {out.append("itob\n");}
    "itod"               {out.append("itod\n");}
    "new"                {out.append("new\n");}
    "NewArray"           {out.append("NewArray\n");}
    "null"               {out.append("null\n");}
    "Print"              {out.append("Print\n");}
    "private"            {out.append("private\n");}
    "public"             {out.append("public\n");}
    "ReadInteger"        {out.append("ReadInteger\n");}
    "ReadLine"           {out.append("ReadLine\n");}
    "return"             {out.append("return\n");}
    "string"             {out.append("string\n");}
    "this"               {out.append("this\n");}
    "void"               {out.append("void\n");}
    "while"              {out.append("while\n");}



	"+"					 {out.append("+\n");}
	"-"			    	 {out.append("-\n");}
	"*"					 {out.append("*\n");}
	"/"					 {out.append("/\n");}
	"%"					 {out.append("%\n");}
    "<"					 {out.append("<\n");}
    "<="				 {out.append("<=\n");}
    ">"					 {out.append(">\n");}
    ">="				 {out.append(">=\n");}
	"="					 {out.append("=\n");}
    "+="				 {out.append("+=\n");}
	"-="				 {out.append("-=\n");}
    "*="				 {out.append("*=\n");}
	"/="				 {out.append("/=\n");}
    "=="				 {out.append("==\n");}
    "!="				 {out.append("!=\n");}
	"&&"				 {out.append("&&\n");}
 	"||"				 {out.append("||\n");}
	"!"				     {out.append("!\n");}
	";"		    		 {out.append(";\n");}
	","				     {out.append(",\n");}
    "."				     {out.append(".\n");}
	"["				     {out.append("[\n");}
	"]"				     {out.append("]\n");}
	"("				     {out.append("(\n");}
	")"					 {out.append(")\n");}
	"{"					 {out.append("{\n");}
	"}"					 {out.append("}\n");}

    //Literal detect action
    {BooleanLiteral}     {out.append("T_BOOLEANLITERAL "+ yytext()+"\n");}
    {IntLiteral}         {out.append("T_INTLITERAL "+ yytext()+"\n");}
    {DoubleLiteral}      {out.append("T_DOUBLELITERAL "+ yytext()+"\n");}

    //Identifier detect action
    {Identifier}         {out.append("T_ID " + yytext() +"\n");}

    //WhiteSpace detect action
    {WhiteSpace}         {/*ignore*/}

    //Comment detect action
    {Comment}            {/*ignore*/}

    //String detect action
    "\""                 {yybegin(STRING); string.append(yytext());}
}

<STRING> {
    "\""    {
        yybegin(YYINITIAL);
        out.append("T_STRINGLITERAL " + string.toString() + yytext() + "\n");
        string.delete(0,string.length());
    }
   "\\\""                {string.append(yytext());}
   .                     {string.append(yytext());}
}

