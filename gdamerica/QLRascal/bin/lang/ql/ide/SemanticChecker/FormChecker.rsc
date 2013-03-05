/**
 * This module contains the source for Form checker (hooked up to the IDE) 
 * This module contains functions to check a whole form and check for available error messages
 * @author  Gerson Delgado
 * @version 1.0, 11/02/2013
 */
 
module lang::ql::ide::SemanticChecker::FormChecker

import lang::ql::ast::AST;
import lang::ql::ide::SemanticChecker::DataTypeChecker;
import lang::ql::ide::SemanticChecker::QuestionChecker;
import lang::ql::ide::SemanticChecker::Environment;
import lang::ql::util::Implode;
import Message;

public ENV checkForm(Form f){                                                
 	if(form(str fIdent, list[Element] fElements ) := f){	 
		ENV env = <{},[],[]>; 
     	env0 = checkQstnDuplicates(fElements, env);
     	env1 = checkListElements(fElements, env0);
     	env2 = checkDuplicateLabels(env1);
     	env3 = checkCyclic(fElements, env2);
	 	return env3;
  } else
     	throw "Syntax Error";
}
                                                                     
public ENV checkForm(loc l) 
	= checkForm(load(l));
	
public set[Message] checkQl(Form f) 
	= getMessages(checkForm(f));

