/**
 * This module define the user-defined DataTypes 
 * and all corresponding constructors for each alternative  
 * @author  Gerson Delgado
 * @version 1.0, 20/01/2013
 */
 
module lang::ql::ast::AST

data Expr
  = ident(str name)
  | \int(int iValue)
  | boolCon(bool bValue)
  | strCon(str strValue)
  | pos(Expr posValue)
  | neg(Expr negValue)
  | not(Expr notValue)
  | mul(Expr lhsValue, Expr rhsValue)
  | div(Expr lhsValue, Expr rhsValue)
  | add(Expr lhsValue, Expr rhsValue)
  | sub(Expr lhsValue, Expr rhsValue)
  | lt(Expr lhsValue, Expr rhsValue)
  | leq(Expr lhsValue, Expr rhsValue)
  | gt(Expr lhsValue, Expr rhsValue)
  | geq(Expr lhsValue, Expr rhsValue)
  | eq(Expr lhsValue, Expr rhsValue)
  | neq(Expr lhsValue, Expr rhsValue)
  | and(Expr lhsValue, Expr rhsValue)
  | or(Expr lhsValue, Expr rhsValue)
  ;
  
data Form
  = form(str fIdent, list[Element] fElements )
  ;

data Element
  = question(Question qstn)
  | condition(Condition cond)
  ;
  
data Question
  = singleQuestion(str qstnIdent, str qstnLabel, DataType qstnDataType)
  | computableQuestion(str cqstnIdent, str cqstnLabel, DataType cqstnDataType, Expr cqstnExpr)
  ;

data Condition
  = singleIfCondition(Expr ifEval, list[Element] ifQstns)
  | ifElseCondition(Expr ifEval, list[Element] ifQstns, list[Element] elseQstns)
  ;
  
data DataType
  = integer()
  | boolean()
  | string()
  ;
  
anno loc Question@location;
anno loc Condition@location;
anno str Condition@id;
anno loc DataType@location;
anno loc Expr@location;
anno loc Form@location;
anno loc Element@location; 




  
    
  
  