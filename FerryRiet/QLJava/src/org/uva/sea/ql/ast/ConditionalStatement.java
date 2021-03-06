package org.uva.sea.ql.ast;

public class ConditionalStatement extends Statement {
	
	private Expr expression ;
	private CompoundBlock compound ;

	public ConditionalStatement(Expr ex, CompoundBlock c) {
		expression = ex ;
		compound = c ;
	}
	public void eval() {
		System.out.print("if (");
		expression.eval() ;
		System.out.print(") ");
		compound.eval();
	}
}
