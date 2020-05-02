package fr.n7.stl.block;

class Driver {

	public static void main(String[] args) throws Exception {
		Parser parser = null;	
		if (args.length == 0) {
			//String fn = "pgcd.bloc";
			String fn = "tests-miniprojet/test212.block";
			parser = new Parser( fn );
			parser.parse();
		} else {/*if (args[0].equals("test")) {
			String[] fn = new String[104];
			
			for (int i = 0; i<104; i++) {
				if (i < 10) {
					System.out.println("tests/test0" + i + ".bloc");
					fn[i] = "tests/test0" + i + ".bloc";
				} else {
					fn[i] = "tests/test" + i + ".bloc";
				}
				System.out.println(fn[i]);
				parser = new Parser( fn[i] );
				parser.parse();
			} 
		} else {*/
			for (String name : args) {
				System.out.println(name);
				parser = new Parser( name );
				parser.parse();
			}
		}
	}
	
}