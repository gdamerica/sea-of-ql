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
			'public class <id> extends JFrame implements ActionListener, CaretListener, MouseMotionListener, Runnable{
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
			'	<genJavaRun(jenv)>
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
			'	Thread t = new Thread(frame);
			'	t.start();
			'}";
}
private str genJavaActions(JENV jenv){
	list[str] output = [];
	list[str] created = [];
	list[str] ids = [obj.id | obj <- jenv.qstns];
	list[str] tempCond = [obj.condExpr | obj <- jenv.qstns, !(obj.cond == ""), (obj.condExpr in ids)];	
	for(obj <- jenv.qstns){
		if((obj.condExpr notin created) && (obj.id notin created) && (obj.condExpr in tempCond)){
			output += genJavaAction(jenv,true,obj);
			created += obj.condExpr;
		}
	}
	return ListToStr(output);
}
/**
* This function will generate the JAVA funcionality 
*/ 
private str genJavaAction(JENV jenv, bool objType, tuple[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] theObj){
	str header = "";
	str objects = "";
	str elseObjects = "";
	str rmvObjects = "";
	str rmvElseObjects = "";
	str output = "";
	list[str] created = [];
	list[str] listObj = [];
	list[str] listElseObj = [];
	
			for(obj <- jenv.qstns){
				if(obj.condExpr == theObj.condExpr){
					if(obj.cond == "if else"){
						rmvObjects +=  "panel.remove(<obj.id>jLabel);\n";
						if(obj.qstnDataType == "boolean"){
							rmvObjects +=  "panel.remove(<obj.id>yes);\n";
						}else{
							rmvObjects +=  "panel.remove(<obj.id>Textf);\n";
						}
					}
					if(obj.cond == "else"){
						rmvElseObjects +=  "panel.remove(<obj.id>jLabel);\n";
						if(obj.qstnDataType == "boolean"){
							rmvElseObjects +=  "panel.remove(<obj.id>yes);\n";
						}else{
							rmvElseObjects +=  "panel.remove(<obj.id>Textf);\n";
						}
					}
				}
			}
		for(obj <- jenv.qstns){
			if((obj.id notin created) && (obj.expr == "") && (obj.condExpr == theObj.condExpr) && (obj.cond != "else")){
				listObj += genJavaSimObjHandlers(obj);
				created += obj.id;
			}
		}
		listObj = reverse(listObj);	
		
		for(obj <- jenv.qstns){
			if((obj.id notin created) && !(obj.expr == "") &&(obj.condExpr == theObj.condExpr) && (obj.cond != "else")){
				listObj += genJavaCompObjHandlers(obj);
				created += obj.id;
			}
		}
		objects += ListToStr(listObj);	
			if(objType){	
				header  = 	"public void check<theObj.condExpr>(){
							'	if(<theObj.condExpr>){
							'		<theObj.condExpr> = false;
							'		Ans<theObj.condExpr> = \"Yes\";
							'		map.put(\"<theObj.condExpr>\", Ans<theObj.condExpr>);";
			} else {
				header  = 	"public void run() {
							'panel.addMouseMotionListener(new MouseMotionListener() {
				 			'@Override
				 			'public void mouseMoved(MouseEvent arg0) {
				 			'	try {
				 			'	if(<theObj.condExpr>){
							'	 	<theObj.id> = \"Yes\";
							'		map.put(\"<theObj.id>\", <theObj.id>);\n";
			}				
		
		if(theObj.cond == "if"){
			output += 	"<header>
					' 	<objects>
	 				'panel.revalidate();
					'validate();
					'pack(); 
					'	}
					'}\n";	
		} else {
			for(obj <- jenv.qstns){
				if((obj.id notin created) && (obj.expr == "") && (obj.condExpr == theObj.condExpr) && (obj.cond == "else")){
					listElseObj += genJavaSimObjHandlers(obj);
					created += obj.id;
				}
			}
			for(obj <- jenv.qstns){
				if((obj.id notin created) && !(obj.expr == "") &&(obj.condExpr == theObj.condExpr) && (obj.cond == "else")){
					listElseObj += genJavaCompObjHandlers(obj);
					created += obj.id;
				}
			}
			elseObjects += ListToStr(listElseObj);	
		
						output += 	"<header>
									' 	<objects>
									'<rmvElseObjects>
									'panel.revalidate();
									'validate();
									'pack(); 
									' } else {
									'	<theObj.condExpr> = true;
									'	<elseObjects>
									'<rmvObjects>
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
	list[str] fil = [obj.id | obj <- jenv.qstns, (obj.cond == ""), (obj.id notin tempCond)];
	for(obj <- jenv.qstns){
		if(obj.id in fil){
			if(obj.qstnDataType == "boolean"){ 
				output += "public void check<obj.id>(){
						'	Ans<obj.id> = \"Yes\";
						'	map.put(\"<obj.id>\", Ans<obj.id>);\n
						'}\n";
			} else {
				output += "public void check<obj.id>(){
						'	<obj.id> = \"Yes\";
						'	map.put(\"<obj.id>\", <obj.id>);\n
						'}\n";
			}	
		}
	}
	return output;
}
private str genJavaRun(JENV jenv){
	bool found = false;
	list[str] output = [];
	list[str] created = [];
	list[str] ids = [obj.id | obj <- jenv.qstns];
	list[str] fil = [obj.condExpr | obj <- jenv.qstns, !(obj.cond == ""), (obj.condExpr notin ids)];	
	for(obj <- jenv.qstns){
		if((obj.condExpr in fil) && (obj.condExpr notin created)){
			output += genJavaAction(jenv,false,obj);
			created += obj.condExpr;
			found = true;
		}
	}
	if(found){
		output += 	" 	catch(NumberFormatException e) {
					'		invalidInput();
					'	}
					'}
					'@Override
					'	public void mouseDragged(MouseEvent e) {
					'	// TODO Auto-generated method stub
					'	}
					'});
					'	try {
					'		Thread.sleep(5000);
	    			'		} catch (InterruptedException e1) {
					'			// TODO Auto-generated catch block
					'			e1.printStackTrace();
	    			'		}
					'}\n";	
	} else {
		output += 	"public void run() {
					'	// TODO Auto-generated method stub
					'}\n";
	}			 		
	return ListToStr(output);
}
private str genJavaCompObjHandlers(tuple[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] obj){
	str output = "";
	if(!(obj.expr == "") && !(obj.cond == "")){
			output +=	"panel.add(<obj.id>jLabel);
						'qstn.add(<obj.id>label);
						'labels.add(\"<obj.id>\");
			 			'panel.add(<obj.id>Textf);
			 			'<obj.id>Textf.setText(\"000\");
						'<obj.id>Textf.setEditable(false);
						'<obj.id>Textf.addMouseMotionListener(this);
				 		'addMouseMotionListener(this);
				 		'<obj.id>Textf.addMouseMotionListener(new MouseMotionListener() {
				 		'@Override
				 		'public void mouseMoved(MouseEvent arg0) {
				 		'	try {
				 		'		<obj.id>valf1 = <obj.lhs>;
				 		'		<obj.id>valf2 = <obj.rhs>;
				 		'		<obj.id>valres = <obj.id>valf1 <obj.expr> <obj.id>valf2;
				 		'		<obj.id> = <obj.id>valres;
				 		'		map.put(\"<obj.id>\", Integer.toString(<obj.id>));
				 		'		<obj.id>Textf.setText(Integer.toString(<obj.id>));
				 		'	}
				 		' 	catch(NumberFormatException e) {
				 		'		invalidInput();
				 		'	}
				 		'}
				 		'@Override
				 		'public void mouseDragged(MouseEvent e) {
				 		'	// TODO Auto-generated method stub
				 		'}
				 		'});\n";		 		
			}
	return output;
}

private str genJavaSimObjHandlers(tuple[str id, str label, str qstnDataType, str expr, str lhs, str rhs, str cond, str condExpr] theObj){
	str output = "";
	output += 	"panel.add(<theObj.id>jLabel);
				'qstn.add(<theObj.id>label);
				'labels.add(\"<theObj.id>\");\n";
		if(theObj.qstnDataType == "boolean"){ 
			output += 	"panel.add(<theObj.id>yes);
						'<theObj.id>yes.addActionListener(new ActionListener() {
					 	'	@Override\n
					 	'	public void actionPerformed(ActionEvent e) {
						'		check<theObj.id>();
					 	'	}
					 	'});\n";
		}
		if(theObj.qstnDataType == "string"){ 
			output += 	"panel.add(<theObj.id>Textf);
						'<theObj.id>Textf.setText(\"000\");
					 	'<theObj.id>Textf.addCaretListener(new CaretListener() {
					 	'	@Override
						'	public void caretUpdate(CaretEvent arg0) {
					 	'		<theObj.id> = <theObj.id>Textf.getText();
					 	'		map.put(\"<theObj.id>\", <theObj.id>);
					 	'	}
					 	'});\n";
		}
		if(theObj.qstnDataType == "int"){ 
			output += 	"panel.add(<theObj.id>Textf);
						'<theObj.id>Textf.setText(\"000\");
					 	'<theObj.id>Textf.addCaretListener(new CaretListener() {
					 	'	@Override
						'	public void caretUpdate(CaretEvent arg0) {
						' 	<theObj.id> = Integer.parseInt(<theObj.id>Textf.getText().toString());
    					' 	map.put(\"<theObj.id>\", Integer.toString(<theObj.id>));
					 	'	}
					 	'});\n";
		}
	return output;
}
    
private str genJavaObjects(JENV jenv){
	str output = "";
	list[str] lsOutput = [];
	for(obj <- jenv.qstns){
	output += 	"static String <obj.id>label = <obj.label>;
				'JLabel <obj.id>jLabel = new JLabel(<obj.id>label);\n";	
			if(obj.qstnDataType == "boolean"){ 
			output += 	"final JCheckBox <obj.id>yes = new JCheckBox(\"Yes\");
						'boolean  <obj.id> = true;
						'String Ans<obj.id> = \"No Answer\";\n";
			}
			if((obj.qstnDataType == "int") && (obj.expr == "")){
				output += 	"final JTextField <obj.id>Textf = new JTextField(5);
							'int <obj.id> = 0;\n";	
			}
			if((obj.qstnDataType == "int") && !(obj.expr == "")){
				output += 	"int <obj.id>valf1 = 0; 
							'int <obj.id>valf2 = 0;
							'int <obj.id>valres = 0; 
							'final JTextField <obj.id>Textf = new JTextField(5);
							'int <obj.id> = 0;\n";	
			}
			if((obj.qstnDataType == "string") && (obj.expr == "")){
				output += 	"final JTextField <obj.id>Textf = new JTextField(10);
							'String <obj.id> = \"No Answer\";\n";	
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