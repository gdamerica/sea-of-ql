package org.uva.sea.ql.ast;

public class Sub extends Expr {

	public Sub(Expr result, Expr rhs) {
		super(result, rhs);
	}
	public void eval() {

		exLeftHand.eval();

		System.out.print(" == ");

		exRightHand.eval();

	}
}
