package org.uva.sea.ql.ast;

public class Ident extends Expr {

	private final String name;

	public Ident(String name) {
		super(null,null) ;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void eval() {
		System.out.print(name);
	}
}
