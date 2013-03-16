/**
 * This module contains code revelant to the IDE Java generator 
 * contains functions in order to add new elements to the JENV
 * @author  Gerson Delgado
 * @version 1.0, 27/02/2013
 */
module lang::ql::ide::JavaGenerator::Environment

import lang::ql::ast::AST;

alias JENV = tuple[ 
	rel[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] qstns
	];

private JENV addJavaQstn(JENV jenv, str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr){ 
	if(id notin jenv.qstns.id){
		return jenv[qstns = jenv.qstns + <id, label, qstnDataType, expr, lhs, rhs, cond, condExpr> ];
	}
	return jenv;
} 


public JENV genJenv(list[Element] fElems, JENV jenv){
	top-down visit(fElems){
		case qstn:computableQuestion(_,_,_,_) 
			: jenv = genJenv(qstn, jenv);
		case qstn:singleQuestion(_,_,_) 
			: jenv = genJenv(qstn, jenv);
		case cond:singleIfCondition(_,_) 
			: jenv = genJenv(cond, jenv);
		case cond:ifElseCondition(_,_,_) 
			: jenv = genJenv(cond, jenv);
	}
	return jenv;	
}

	
private JENV genJenv(singleQuestion(str qstnIdent, str qstnLabel, DataType qstnDataType), JENV jenv)
	= addJavaQstn(jenv, qstnIdent, qstnLabel, genStrDataType(qstnDataType),"","","","","");

private JENV genJenv(computableQuestion(str cqstnIdent, str cqstnLabel, DataType cqstnDataType, Expr cqstnExpr), JENV jenv)
	= addJavaQstn(jenv, cqstnIdent, cqstnLabel, genStrDataType(cqstnDataType), genQstnStrExpr(cqstnExpr),genStrLhsExpr(cqstnExpr),genStrRhsExpr(cqstnExpr),"","");

private JENV genJenv(singleIfCondition(Expr ifEval, list[Element] ifQstns), JENV jenv)
	= genIfCondQstn(ifQstns, jenv, genStrExpr(ifEval));


private JENV genJenv(ifElseCondition(Expr ifEval, list[Element] ifQstns, list[Element] elseQstns), JENV jenv){
	jenv0 = genIfElseCondQstn(ifQstns, jenv, genStrExpr(ifEval));
	return jenv1 = genElseCondQstn(elseQstns, jenv0, genStrExpr(ifEval));
}

private JENV genIfCondQstn(list[Element] ifQstns, JENV jenv, str condExpr){
	top-down visit(ifQstns){
		case qstn:singleQuestion(str qstnIdent, str qstnLabel, DataType qstnDataType) 
			: jenv = addJavaQstn(jenv, qstnIdent, qstnLabel, genStrDataType(qstnDataType),"","","","if",condExpr);
		case qstn:computableQuestion(str cqstnIdent, str cqstnLabel, DataType cqstnDataType, Expr cqstnExpr) 
			: jenv = addJavaQstn(jenv, cqstnIdent, cqstnLabel, genStrDataType(cqstnDataType), genQstnStrExpr(cqstnExpr),genStrLhsExpr(cqstnExpr),genStrRhsExpr(cqstnExpr),"if",condExpr);
	}
  return jenv;
}

private JENV genIfElseCondQstn(list[Element] ifQstns, JENV jenv, str condExpr){
	top-down visit(ifQstns){
		case qstn:singleQuestion(str qstnIdent, str qstnLabel, DataType qstnDataType) 
			: jenv = addJavaQstn(jenv, qstnIdent, qstnLabel, genStrDataType(qstnDataType),"","","","if else",condExpr);
		case qstn:computableQuestion(str cqstnIdent, str cqstnLabel, DataType cqstnDataType, Expr cqstnExpr) 
			: jenv = addJavaQstn(jenv, cqstnIdent, cqstnLabel, genStrDataType(cqstnDataType), genQstnStrExpr(cqstnExpr),genStrLhsExpr(cqstnExpr),genStrRhsExpr(cqstnExpr),"if else",condExpr);
	}
  return jenv;
}

private JENV genElseCondQstn(list[Element] elseQstns, JENV jenv, str condExpr){
	top-down visit(elseQstns){
		case qstn:singleQuestion(str qstnIdent, str qstnLabel, DataType qstnDataType) 
			: jenv = addJavaQstn(jenv, qstnIdent, qstnLabel, genStrDataType(qstnDataType),"","","","else",condExpr);
		case qstn:computableQuestion(str cqstnIdent, str cqstnLabel, DataType cqstnDataType, Expr cqstnExpr) 
			: jenv = addJavaQstn(jenv, cqstnIdent, cqstnLabel, genStrDataType(cqstnDataType), genQstnStrExpr(cqstnExpr),genStrLhsExpr(cqstnExpr),genStrRhsExpr(cqstnExpr),"else",condExpr);
	}
  return jenv;
}

private str genStrDataType(DataType dt){
	str output = "";
	top-down visit (dt){
		case integer() 
			: output = "int";
		case boolean()
			: output = "boolean";
		case string()
			: output = "string";
	}
	return output;
}

private str genStrIdent(Expr expr){
	str output = "";
	top-down visit (expr){
		case ident(str name)
			: output = "<name>";
		case \int(int iValue)
			: output = "<iValue>";
		case boolCon(bool bValue)
			: output = "<bValue>";
		case strCon(str strValue)
			: output = "<strValue>";
																			
	}
	return output;	
}
	
private str genQstnStrExpr(Expr expr){
	str output = "";
	top-down visit (expr){
		case sub(_, _) 
			: output = "-";
		case add(_, _) 
			: output = "+";
		case div(_, _) 
			: output = "/";
		case mul(_, _) 
			: output = "*";																
	}
	return output;	
}

private str genStrLhsExpr(Expr expr){
	str output = "";
	top-down visit (expr){
		case sub(lhs, rhs) 
			: output = "<genStrIdent(lhs)>";
		case add(lhs, rhs) 
			: output = "<genStrIdent(lhs)>";
		case div(lhs, rhs) 
			: output = "<genStrIdent(lhs)>";
		case mul(lhs, rhs) 
			: output = "<genStrIdent(lhs)>";																	
	}
	return output;	
}

private str genStrRhsExpr(Expr expr){
	str output = "";
	top-down visit (expr){
	    case ident(str name)
			: output = genStrIdent(expr);
		case sub(lhs, rhs) 
			: output = "<genStrIdent(rhs)>";
		case add(lhs, rhs) 
			: output = "<genStrIdent(rhs)>";
		case div(lhs, rhs) 
			: output = "<genStrIdent(rhs)>";
		case mul(lhs, rhs) 
			: output = "<genStrIdent(rhs)>";																	
	}
	return output;	
}

private str genStrExpr(Expr expr){
	str output = "";
		visit (expr){
	    case ident(str name)
			: output = genStrIdent(expr);
		case eq(lhs, rhs) 
			: output = "<genStrIdent(lhs)> == <genStrIdent(rhs)>";
		case neq(lhs, rhs) 
			: output = "<genStrIdent(lhs)> != <genStrIdent(rhs)>";
		case geq(lhs, rhs) 
			: output = "<genStrIdent(lhs)> \>= <genStrIdent(rhs)>";
		case gt(lhs, rhs) 
			: output = "<genStrIdent(lhs)> \> <genStrIdent(rhs)>";	
		case leq(lhs, rhs) 
			: output = "<genStrIdent(lhs)> \<= <genStrIdent(rhs)>";
		case lt(lhs, rhs) 
			: output = "<genStrIdent(lhs)> \< <genStrIdent(rhs)>";	
		case sub(lhs, rhs) 
			: output = "<genStrIdent(lhs)> - <genStrIdent(rhs)>";
		case add(lhs, rhs) 
			: output = "<genStrIdent(lhs)> + <genStrIdent(rhs)>";
		case div(lhs, rhs) 
			: output = "<genStrIdent(lhs)> / <genStrIdent(rhs)>";
		case mul(lhs, rhs) 
			: output = "<genStrIdent(lhs)> * <genStrIdent(rhs)>";
		case and(lhs, rhs) 
			: output = "<genStrIdent(lhs)> && <genStrIdent(rhs)>";	
		case or(lhs, rhs) 
			: output = "<genStrIdent(lhs)> || <genStrIdent(rhs)>";
		case not(val) 
			: output = "!<genStrIdent(val)>";	
		case neg(val) 
			: output = "-<genStrIdent(val)>";
		case pos(val) 
			: output = "+<genStrIdent(val)>";																		
	}
	return output;	
}


	

