import compiler.sym;import java.io.*;
import java.io.IOException;
%%
%public
%class LexerP
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

//definition
Definition="define"

%state STRING
%%

<YYINITIAL>{
    "__func__"           {return tokenize(sym.FUNCTION);}
    "__line__"           {return tokenize(sym.LINE);}
    "bool"               {return tokenize(sym.BOOLEAN);}
    "break"              {return tokenize(sym.BREAK);}
    "btoi"               {return tokenize(sym.BTOI);}
    "class"              {return tokenize(sym.CLASS);}
    "continue"           {return tokenize(sym.CONTINUE);}
    "double"             {return tokenize(sym.DOUBLE);}
    "dtoi"               {return tokenize(sym.DTOI);}
    "else"               {return tokenize(sym.ELSE);}
    "for"                {return tokenize(sym.FOR);}
    "if"                 {return tokenize(sym.IF);}
    "import"             {return tokenize(sym.IMPORT);}
    "int"                {return tokenize(sym.INTEGER);}
    "itob"               {return tokenize(sym.ITOB);}
    "itod"               {return tokenize(sym.ITOD);}
    "new"                {return tokenize(sym.NEW);}
    "NewArray"           {return tokenize(sym.NEWARRAY);}
    "null"               {return tokenize(sym.NULL);}
    "Print"              {return tokenize(sym.PRINT);}
    "private"            {return tokenize(sym.PRIVATE);}
    "public"             {return tokenize(sym.PUBLIC);}
    "ReadInteger"        {return tokenize(sym.READINTEGER);}
    "ReadLine"           {return tokenize(sym.READLINE);}
    "return"             {return tokenize(sym.RETURN);}
    "string"             {return tokenize(sym.STRING);}
    "this"               {return tokenize(sym.THIS);}
    "void"               {return tokenize(sym.VOID);}
    "while"              {return tokenize(sym.WHILE);}
    "__df"             {return tokenize(sym.DEFINE);}

	"+"					 {return tokenize(sym.ADD);}
	"-"			    	 {return tokenize(sym.SUB);}
	"*"					 {return tokenize(sym.MUL);}
	"/"					 {return tokenize(sym.DIV);}
	"%"					 {return tokenize(sym.MOD);}
    "<"					 {return tokenize(sym.LESS);}
    "<="				 {return tokenize(sym.LESSEQUAL);}
    ">"					 {return tokenize(sym.GREATER);}
    ">="				 {return tokenize(sym.GREATEREQUAL);}
	"="					 {return tokenize(sym.ASSIGN);}
    "+="				 {return tokenize(sym.ASSIGNADD);}
	"-="				 {return tokenize(sym.ASSIGNSUB);}
    "*="				 {return tokenize(sym.ASSIGNMUL);}
	"/="				 {return tokenize(sym.ASSIGNDIV);}
    "=="				 {return tokenize(sym.EQUAL);}
    "!="				 {return tokenize(sym.NOTEQUAL);}
	"&&"				 {return tokenize(sym.AND);}
 	"||"				 {return tokenize(sym.OR);}
	"!"				     {return tokenize(sym.NOT);}
	";"		    		 {return tokenize(sym.SEMICOLON);}
	","				     {return tokenize(sym.COMMA);}
    "."				     {return tokenize(sym.DOT);}
	"["				     {return tokenize(sym.LEFTBRACKET);}
	"]"				     {return tokenize(sym.RIGHTBRACKET);}
	"("				     {return tokenize(sym.LEFTPARANTHESIS);}
	")"					 {return tokenize(sym.RIGHTPARANTHESIS);}
	"{"					 {return tokenize(sym.LEFTCURLY);}
	"}"					 {return tokenize(sym.RIGHTCURLY);}

    //Literal detect action
    {BooleanLiteral}     {return tokenize(sym.BOOLCONST, yytext());}
    {IntLiteral}         {return tokenize(sym.INTCONST, yytext());}
    {DoubleLiteral}      {return tokenize(sym.DOUBLECONST, yytext());}

    //Identifier detect action
    {Identifier}         {return tokenize(sym.IDENTIFIER, yytext());}

    //WhiteSpace detect action
    {WhiteSpace}         {/*ignore*/}

    //Comment detect action
    {Comment}            {/*ignore*/}

    //String detect action
    "\""                 {yybegin(STRING); string.append(yytext());}
     [^]                 {return tokenize(sym.error);}

}

<STRING> {
    "\""    {
        yybegin(YYINITIAL);
        string.delete(0,string.length());
        return tokenize(sym.STRINGCONST, string.toString() + yytext());
    }
   "\\\""                {string.append(yytext());}
   .                     {string.append(yytext());}
}
