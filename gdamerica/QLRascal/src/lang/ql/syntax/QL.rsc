/**
 * This module contains all the QL syntax,lexical,layout and keywords definitions   
 * @author  Gerson Delgado
 * @version 1.0, 19/01/2013
 */

module lang::ql::syntax::QL
 
start syntax Expr
  = ident: Ident name
  | \int: Int integer
  | boolCon: Boolean boolean
  | strCon: String string
  | bracket "(" Expr arg ")"
  | pos: "+" Expr 
  | neg: "-" Expr 
  | not: "!" Expr
  > left (
      mul: Expr "*" Expr
    | div: Expr "/" Expr
  )
  > left (
      add: Expr "+" Expr
    | sub: Expr "-" Expr
  )
  > non-assoc (
      lt: Expr "\<" Expr
    | leq: Expr "\<=" Expr
    | gt: Expr "\>" Expr
    | geq: Expr "\>=" Expr
    | eq: Expr "==" Expr
    | neq: Expr "!=" Expr
  )
  > left and: Expr "&&" Expr
  > left or: Expr "||" Expr
  ;
  
start syntax DataType
  = integer: "int"
  | boolean: "boolean"
  | string: "string"
  ;  
        
start syntax Form
  = form: "form" Ident identification "{" Element* formElement "}" 
  ;

start syntax Element
  = question: Question question
  | condition: Condition condition
  ;
    
start syntax Question
  = singleQuestion: Ident identification ":" String label DataType datatype 
  | computableQuestion: Ident identification ":" String label DataType datatype Expr computableExpression 
  ;
   
start syntax Condition
  = singleIfCondition: "if" Expr evaluation "{" Element+ questions "}"
  | ifElseCondition: "if" Expr evaluation "{" Element+ questions "}" "else" "{" Element+ questions "}"   
  ;
        
syntax WhitespaceOrComment 
  = whitespace: Whitespace
  | comment: Comment
  ;   
  
lexical Ident 
  = ([a-z A-Z 0-9 _] !<< [a-z A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9 _]) \ Keywords
  ;

lexical Int
  = [0-9]+ !>> [0-9]
  ;
  
lexical Boolean
  = "true"
  | "false"
  ;

lexical String
  = "\"" ![\"]* "\"" 
  ;
   
lexical Comment 
  = @category="Comment" "/*" CommentChar* "*/"
  | @category="Comment" "//" ![\n]* $
  ;

lexical CommentChar
  = ![*]
  | [*] !>> [/]
  ;

lexical Whitespace 
  = [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000]
  ;    

layout Standard 
  = WhitespaceOrComment* !>> [\ \t\n\f\r] !>> "//" !>> "/*"
  ; 

keyword Keywords 
  = "true"
  | "false"
  | "if"
  | "else"
  | "boolean"
  | "int"
  | "form"
  | "label"
  ; 
    
 
 