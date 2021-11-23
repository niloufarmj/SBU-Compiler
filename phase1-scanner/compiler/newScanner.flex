import compiler.sym;import java.io.*;
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

    public Symbol tokenize (int tokenType, Object... value) {
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
    "__func__"           {tokenize(sym.FUNCTION);}
    "__line__"           {tokenize(sym.LINE);}
    "bool"               {tokenize(sym.BOOLEAN);}
    "break"              {tokenize(sym.BREAK);}
    "btoi"               {tokenize(sym.BTOI);}
    "class"              {tokenize(sym.CLASS);}
    "continue"           {tokenize(sym.CONTINUE);}
    "double"             {tokenize(sym.DOUBLE);}
    "dtoi"               {tokenize(sym.DTOI);}
    "else"               {tokenize(sym.ELSE);}
    "for"                {tokenize(sym.FOR);}
    "if"                 {tokenize(sym.IF);}
    "import"             {tokenize(sym.IMPORT);}
    "int"                {tokenize(sym.INTEGER);}
    "itob"               {tokenize(sym.ITOB);}
    "itod"               {tokenize(sym.ITOD);}
    "new"                {tokenize(sym.NEW);}
    "NewArray"           {tokenize(sym.NEWARRAY);}
    "null"               {tokenize(sym.NULL);}
    "Print"              {tokenize(sym.PRINT);}
    "private"            {tokenize(sym.PRIVATE);}
    "public"             {tokenize(sym.PUBLIC);}
    "ReadInteger"        {tokenize(sym.READINTEGER);}
    "ReadLine"           {tokenize(sym.READLINE);}
    "return"             {tokenize(sym.RETURN);}
    "string"             {tokenize(sym.STRING);}
    "this"               {tokenize(sym.THIS);}
    "void"               {tokenize(sym.VOID);}
    "while"              {tokenize(sym.WHILE);}


	"+"					 {tokenize(sym.ADD);}
	"-"			    	 {tokenize(sym.SUB);}
	"*"					 {tokenize(sym.MUL);}
	"/"					 {tokenize(sym.DIV);}
	"%"					 {tokenize(sym.MOD);}
    "<"					 {tokenize(sym.LESS);}
    "<="				 {tokenize(sym.LESSEQUAL);}
    ">"					 {tokenize(sym.GREATER);}
    ">="				 {tokenize(sym.GREATEREQUAL);}
	"="					 {tokenize(sym.ASSIGN);}
    "+="				 {tokenize(sym.ASSIGNADD);}
	"-="				 {tokenize(sym.ASSIGNSUB);}
    "*="				 {tokenize(sym.ASSIGNMUL);}
	"/="				 {tokenize(sym.ASSIGNDIV);}
    "=="				 {tokenize(sym.EQUAL);}
    "!="				 {tokenize(sym.NOTEQUAL);}
	"&&"				 {tokenize(sym.AND);}
 	"||"				 {tokenize(sym.OR);}
	"!"				     {tokenize(sym.NOT);}
	";"		    		 {tokenize(sym.SEMICOLON);}
	","				     {tokenize(sym.COMMA);}
    "."				     {tokenize(sym.DOT);}
	"["				     {tokenize(sym.LEFTBRACKET);}
	"]"				     {tokenize(sym.RIGHTBRACKET);}
	"("				     {tokenize(sym.LEFTPARANTHESIS);}
	")"					 {tokenize(sym.RIGHTPARANTHESIS);}
	"{"					 {tokenize(sym.LEFTCURLY);}
	"}"					 {tokenize(sym.RIGHTCURLY);}

    //Literal detect action
    {BooleanLiteral}     {tokenize(sym.BOOLEAN, yytext());}
    {IntLiteral}         {tokenize(sym.INTEGER, yytext());}
    {DoubleLiteral}      {tokenize(sym.DOUBLE, yytext());}

    //Identifier detect action
    {Identifier}         {tokenize(sym.IDENTIFIER,yytext() );}

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
        tokenize(sym.STRING, string.toString() + yytext());
        string.delete(0,string.length());
    }
   "\\\""                {string.append(yytext());}
   .                     {string.append(yytext());}
}
