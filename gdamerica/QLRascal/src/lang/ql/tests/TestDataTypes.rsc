/**
 * This module define test functions for each DataType variant
 * A test function is a boolean function without arguments 
 * it can also be called automatically by the unit test framework, by typing :test    
 * @author  Gerson Delgado
 * @version 1.0, 21/01/2013
 */
 
module lang::ql::tests::TestDataTypes

import lang::ql::ast::AST;
import lang::ql::util::Parse;
import ParseTree;

private DataType p(str src) 
	= implode(#DataType, parseDataType(src));

public test bool testInteger() 
	= p("int") is integer;
public test bool testBoolean() 
	= p("boolean") is boolean;
public test bool testString() 
	= p("string") is string;



