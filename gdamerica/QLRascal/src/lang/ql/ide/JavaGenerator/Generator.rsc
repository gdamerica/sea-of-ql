/**
 * This module contains code revelant to the IDE Javafile generator
 * contains functions to generate a correct java syntax  
 * @author  Gerson Delgado
 * @version 1.0, 18/02/2013
 */
module lang::ql::ide::JavaGenerator::Generator

import lang::ql::ast::AST;
import lang::ql::ide::JavaGenerator::Environment;
import List;

 /**
* Generator function that will construct a coherent Java class from a Form
*/ 
public str genJavaFile(form(str id, list[Element] fElems)){
	JENV jenv = <{}>;
 	jenv = genJenv(fElems,jenv);
 	return 	"import net.miginfocom.swing.MigLayout;
		 	'import com.thoughtworks.xstream.XStream;
			'import javax.swing.event.*;
			'import java.awt.event.*;
			'import javax.swing.*;
			'import java.util.*;
			'import java.awt.*;
			'import java.io.*;\n
			'public class <id> extends JFrame implements ActionListener, CaretListener, MouseMotionListener{
			'	private static final long serialVersionUID = 5113924929073384257L;
   		  	'	JPanel panel;
    		'	Queue\<String\> qstn = new LinkedList\<String\>();
    		'	Queue\<String\> ans = new LinkedList\<String\>();
    		'	Queue\<String\> labels = new LinkedList\<String\>();
			'	HashMap\<String, String\> map = new HashMap\<String, String\>();  
    		'	static String Form = \"<id>\";
    		'	String xmlForm;\n
    		'	<genJavaObjects(jenv)>
    		'	<genJavaConstructor(id)>
    		'	public void paintJpanel(){
    		'	panel = new JPanel();
			'	panel.setLayout(new MigLayout(\"wrap 2\"));
			'	add(panel);
			'	<genJpanelObj(jenv)>
			'	setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
			'	pack();
			'	setVisible(true);
			'	}
			'   <genJavaActions(jenv)>
			'	<genJavaSimpleAction(jenv)>
			'	<genJavaXmlHandler(jenv)>
			'	<genMainMethod(id)>
			'    @Override
    		'	public void caretUpdate(CaretEvent arg0){
			'		// TODO Auto-generated method stub
    		'	}
    		'	@Override
    		'	public void actionPerformed(ActionEvent e){
			'		// TODO Auto-generated method stub
			'	}
    		'	@Override
    		'	public void mouseDragged(MouseEvent arg0){
			'		// TODO Auto-generated method stub
			'	}
    		'	@Override
    		'	public void mouseMoved(MouseEvent arg0){
			'		// TODO Auto-generated method stub
   			'	 }
			'}";
 }

private str genJpanelObj(JENV jenv){
	list[str] lsOutput = [genJavaSimObjHandlers(obj), genJavaCompObjHandlers(obj) | obj <- jenv.qstns, (obj.cond == "")];
	return ListToStr(reverse(lsOutput));
}

private str genMainMethod(str id){
	return 	"public static void main(String[]args){
			'	<id> frame = new <id>();
			'}";
}
private str genJavaActions(JENV jenv){
	list[str] output = [];
	list[str] created = [];	
	for(obj <- jenv.qstns){
		if(obj.condExpr notin created){
			output += genJavaAction(jenv,obj);
			created += obj.condExpr;
		}
	}
	return ListToStr(output);
}
private str genJavaAction(JENV jenv, tuple[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] theObj){
	str header = "";
	str objects = "";
	str output = "";
	list[str] tempCond = [obj.condExpr | obj <- jenv.qstns, !(obj.cond == "")];
	list[str] created = [];
	list[str] listObj = [];
		if(theObj.condExpr in tempCond){
			header  = 	"public void check<theObj.condExpr>(){
						'<theObj.cond>(B<theObj.condExpr>){
						' 	B<theObj.condExpr> = false;
						'	<theObj.condExpr> = \"Yes\";
						'	map.put(\"<theObj.condExpr>\", <theObj.condExpr>);";
		for(obj <- jenv.qstns){
			if((obj.id notin created) && (obj.expr == "") && (obj.condExpr == theObj.condExpr)){
				listObj += genJavaSimObjHandlers(obj);
				created += obj.id;
			}
		}
	listObj = reverse(listObj);
		for(obj <- jenv.qstns){
			if((obj.id notin created) && !(obj.expr == "") &&(obj.condExpr == theObj.condExpr)){
				listObj += genJavaCompObjHandlers(obj);
				created += obj.id;
			}
		}
	objects += ListToStr(listObj);	
	output += 	"<header>
				' 	<objects>
	 			'panel.revalidate();
				'validate();
				'pack(); 
				'	}
				'}\n";	
	}			
	return output;			
}

private str genJavaSimpleAction(JENV jenv){
	str output = "";
	list[str] tempCond = [obj.condExpr | obj <- jenv.qstns, !(obj.cond == "")];
	list[str] lsOutput = [];
	for(obj <- jenv.qstns){
		if((obj.id notin tempCond) && (obj.expr == "") && (obj.qstnDataType == "boolean")){
			temp += "public void check<obj.id>(){
					'	<obj.id> = \"Yes\";
					'	map.put(\"<obj.id>\", <obj.id>);\n
					'}\n";
		}
}
	return output;

}

private str genJavaCompObjHandlers(tuple[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] obj){
	str output = "";
	if(!(obj.expr == "") && !(obj.cond == "")){
			output +=	"panel.add(<obj.id>jLabel);
						'qstn.add(<obj.id>label);
						'labels.add(\"<obj.id>\");
			 			'panel.add(<obj.id>Textf);
						'<obj.id>Textf.setEditable(false);
						'<obj.id>Textf.addMouseMotionListener(this);
				 		'addMouseMotionListener(this);
				 		'<obj.id>Textf.addMouseMotionListener(new MouseMotionListener() {
				 		'@Override
				 		'public void mouseMoved(MouseEvent arg0) {
				 		'	try {
				 		'		<obj.id>valf1 = Integer.parseInt(<obj.lhs>);
				 		'		<obj.id>valf2 = Integer.parseInt(<obj.rhs>);
				 		'		<obj.id>valres = <obj.id>valf1 <obj.expr> <obj.id>valf2;
				 		'		<obj.id> = Integer.toString(<obj.id>valres);
				 		'		map.put(\"<obj.id>\", <obj.id>);
				 		'		<obj.id>Textf.setText(<obj.id>);
				 		'	}
				 		' 	catch(NumberFormatException e) {
				 		'		invalidInput();
				 		'	}
				 		'}
				 		'@Override
				 		'public void mouseDragged(MouseEvent e) {
				 		'	// TODO Auto-generated method stub
				 		'}
				 		'});";
	output += "\n";				 		
			}
	return output;
}

private str genJavaSimObjHandlers(tuple[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] obj){
	str output = "";
	output += 	"panel.add(<obj.id>jLabel);
				'qstn.add(<obj.id>label);
				'labels.add(\"<obj.id>\");\n";
		if(obj.qstnDataType == "boolean"){ 
			output += 	"panel.add(<obj.id>yes);
						'<obj.id>yes.addActionListener(new ActionListener() {
					 	'	@Override\n
					 	'	public void actionPerformed(ActionEvent e) {
						'		check<obj.id>();
					 	'	}
					 	'});\n";
		}else{
			output += 	"panel.add(<obj.id>Textf);
					 	'<obj.id>Textf.addCaretListener(new CaretListener() {
					 	'	@Override
						'	public void caretUpdate(CaretEvent arg0) {
					 	'		<obj.id> = <obj.id>Textf.getText();
					 	'		map.put(\"<obj.id>\", <obj.id>);
					 	'	}
					 	'});\n";
	output += "\n";		
	}
	return output;
}
    
private str genJavaObjects(JENV jenv){
	str output = "";
	list[str] lsOutput = [];
	for(obj <- jenv.qstns){
	output += 	"static String <obj.id>label = <obj.label>;
				'String <obj.id> = \"No Answer\";
				'JLabel <obj.id>jLabel = new JLabel(<obj.id>label);\n";	
			if(obj.qstnDataType == "boolean"){ 
			output += 	"boolean B<obj.id> = true;
						'final JCheckBox <obj.id>yes = new JCheckBox(\"Yes\");\n";
			}
			if((obj.qstnDataType == "int") && (obj.expr == "")){
				output += "final JTextField <obj.id>Textf = new JTextField(5);\n";	
			}
			if((obj.qstnDataType == "int") && !(obj.expr == "")){
				output += 	"int <obj.id>valf1 = 0; 
							'int <obj.id>valf2 = 0;
							'int <obj.id>valres = 0; 
							'final JTextField <obj.id>Textf = new JTextField(5);\n";	
			}
			if((obj.qstnDataType == "string") && (obj.expr == "")){
				output += "final JTextField <obj.id>Textf = new JTextField(10);\n";
			}
	output += "\n";	
	lsOutput += output;
	output = "";
	}
	
	return output = ListToStr(reverse(lsOutput));
} 
private str genJavaXmlHandler(JENV jenv){
	return 	"public void save(){
			'	int size = labels.size();
			'	for(int i = 0; i \< size; i++){
			'		if(!labels.isEmpty()){
			'			ans.add(map.get(labels.poll()));
			'	}
			'		}
			'	String xmlFile = makeFile();
			'	try {
			'		String loc = \"//Users//GersonDelgado//Documents//workspace//FormTest//Output//\";
			'		File file = new File(loc + Form +\".xml\");
			' 		BufferedWriter out = new BufferedWriter(new FileWriter(file));
			'		out.write(xmlFile);
			'		out.close();
			'	}
			' 	catch (IOException e)
			' 	{
			'		System.err.println(\"Exception Creating File\");
			'	}
			'	JOptionPane.showMessageDialog(this,\"XML file succesfully saved\");
			'}
			'	public void invalidInput(){
			'		JOptionPane.showMessageDialog(this,\"Empty Value or Incorrect input format, expected int\");
			' 	}\n
			'	public String makeFile(){
			'		int size = qstn.size();
			'		String output = \"\";
			'		XStream xstream = new XStream();
			'		xstream.alias(\"Form\", String.class);
			'		output = xstream.toXML(Form) + System.getProperty(\"line.separator\");
			'		for(int i = 0; i \< size; i++){
			'			if(!qstn.isEmpty()){
			'				xstream.alias(\"Question\", String.class);
			'				output += xstream.toXML(qstn.poll()) + System.getProperty(\"line.separator\");
			'	}
			'			if(!ans.isEmpty()){
			' 				xstream.alias(\"Answer\", String.class);
			'				output += xstream.toXML(ans.poll()) + System.getProperty(\"line.separator\");
			'			 }
			'	}
			'	return output;
			'}";
}

private str genJavaConstructor(str name){
	return 	"public <name>(){
			'	super(Form);
			'	setLayout(new BorderLayout());
			'	JMenuBar menuBar = new JMenuBar();
			'	JMenu menu = new JMenu(\"QL Menu\");
			'	menuBar.add(menu);
			'	JMenuItem save = new JMenuItem(\"SAVE as XML\");
			'	menu.add(save);
			'	save.addActionListener(new ActionListener() {
			'		@Override
			'		public void actionPerformed(ActionEvent e) {
			'		save();
			'		}
			'	});
			'	setJMenuBar(menuBar);
			'	paintJpanel();
			'	}";			  
}

private str ListToStr(list[str] theList){
	str output = "";
	for(e <- theList){
	output += e;
	}
	return output;
}
