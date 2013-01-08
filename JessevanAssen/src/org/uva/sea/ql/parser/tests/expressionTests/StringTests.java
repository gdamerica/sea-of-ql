package org.uva.sea.ql.parser.tests.expressionTests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.uva.sea.ql.ast.ASTNode;
import org.uva.sea.ql.ast.Str;
import org.uva.sea.ql.parser.ParseError;

public class StringTests extends ExpressionTests {
	
	@Test
	public void testString() throws ParseError {
		testString("Henk de Vries!");
	}
	
	@Test
	public void testStringWithEscapedQuote() throws ParseError {
		testString("imma firin mah \\\"LASER\\\"");		
	}
	
	private void testString(String stringValue) throws ParseError {
		ASTNode parsed = parser.parse(String.format("\"%s\"", stringValue));
		assertEquals(Str.class, parsed.getClass());
		assertEquals(stringValue, ((Str) parsed).getValue());
	}
	
}
