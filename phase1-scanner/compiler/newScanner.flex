import java.io.*;
import java.io.IOException;
%%
%public
%class Lexer
%unicode
%cup
%char
%type Symbol
%standalone

%{
    StringBuffer out = new StringBuffer();
    StringBuilder string = new StringBuilder();
    String value;

    public Symbol tokenize (int tokenType , Object... value) {
        Object tokenValue = value.length > 0 ? value[0] : yytext();
        return new Symbol(tokenType, tokenValue);
    }
%}

%eof{

    System.out.println(out.toString());

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
ExpoFloatNumber = {FloatNumber}"E"("-"|"+")?{Digit}+

//Literals
IntLiteral = ({Digit}+) | {HexNumber}
DoubleLiteral = {FloatNumber}|{ExpoFloatNumber}
BooleanLiteral = "false"|"true"


//id
Identifier = [a-zA-Z][a-zA-Z0-9_]*
%state STRING
%%

<YYINITIAL>{
    "__func__"           {tokenize("__func__\n");}
    "__line__"           {tokenize("__line__\n");}
    "bool"               {tokenize("bool\n");}
    "break"              {tokenize("break\n");}
    "btoi"               {tokenize("btoi\n");}
    "class"              {tokenize("class\n");}
    "continue"           {tokenize("continue\n");}
    "double"             {tokenize("double\n");}
    "dtoi"               {tokenize("dtoi\n");}
    "else"               {tokenize("else\n");}
    "for"                {tokenize("for\n");}
    "if"                 {tokenize("if\n");}
    "import"             {tokenize("import\n");}
    "int"                {tokenize("int\n");}
    "itob"               {tokenize("itob\n");}
    "itod"               {tokenize("itod\n");}
    "new"                {tokenize("new\n");}
    "NewArray"           {tokenize("NewArray\n");}
    "null"               {tokenize("null\n");}
    "Print"              {tokenize("Print\n");}
    "private"            {tokenize("private\n");}
    "public"             {tokenize("public\n");}
    "ReadInteger"        {tokenize("ReadInteger\n");}
    "ReadLine"           {tokenize("ReadLine\n");}
    "return"             {tokenize("return\n");}
    "string"             {tokenize("string\n");}
    "this"               {tokenize("this\n");}
    "void"               {tokenize("void\n");}
    "while"              {tokenize("while\n");}


	"+"					 {tokenize("+\n");}
	"-"			    	 {tokenize("-\n");}
	"*"					 {tokenize("*\n");}
	"/"					 {tokenize("/\n");}
	"%"					 {tokenize("%\n");}
    "<"					 {tokenize("<\n");}
    "<="				 {tokenize("<=\n");}
    ">"					 {tokenize(">\n");}
    ">="				 {tokenize(">=\n");}
	"="					 {tokenize("=\n");}
    "+="				 {tokenize("+=\n");}
	"-="				 {tokenize("-=\n");}
    "*="				 {tokenize("*=\n");}
	"/="				 {tokenize("/=\n");}
    "=="				 {tokenize("==\n");}
    "!="				 {tokenize("!=\n");}
	"&&"				 {tokenize("&&\n");}
 	"||"				 {tokenize("||\n");}
	"!"				     {tokenize("!\n");}
	";"		    		 {tokenize(";\n");}
	","				     {tokenize(",\n");}
    "."				     {tokenize(".\n");}
	"["				     {tokenize("[\n");}
	"]"				     {tokenize("]\n");}
	"("				     {tokenize("(\n");}
	")"					 {tokenize(")\n");}
	"{"					 {tokenize("{\n");}
	"}"					 {tokenize("}\n");}

    //Literal detect action
    {BooleanLiteral}     {tokenize("T_BOOLEANLITERAL "+ yytext()+"\n");}
    {IntLiteral}         {tokenize("T_INTLITERAL "+ yytext()+"\n");}
    {DoubleLiteral}      {tokenize("T_DOUBLELITERAL "+ yytext()+"\n");}

    //Identifier detect action
    {Identifier}         {tokenize("T_ID " + yytext() +"\n");}

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
        tokenize("T_STRINGLITERAL " + string.toString() + yytext() + "\n");
        string.delete(0,string.length());
    }
   "\\\""                {string.append(yytext());}
   .                     {string.append(yytext());}
}

