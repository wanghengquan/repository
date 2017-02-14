/*
 * File: conf_parser.java
 * Description: Software configure parser definition
 * Author: Jason.Wang
 * Date:2017/02/14
 * Modifier:
 * Date:
 * Description:
 */
package info_parser;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

/*
 * PlatUML graph
 * @startuml
 * :Hello world;
 * :This is on defined on
 * several **lines**;
 * @enduml
 */
class conf_parser {
	//public property
	//protect property
	//private property
	//public function
	//protect function
	//private function
	
	/*
	 * read properties
	 */	
    public static void readProperties(String filePath) throws FileNotFoundException{
        Properties props = new Properties();
        FileInputStream fis = new FileInputStream(filePath);
        InputStream instr = new BufferedInputStream(fis);
        try {
			props.load(instr);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        Enumeration<?> en = props.propertyNames();
        while (en.hasMoreElements()) {
            String key = (String) en.nextElement();
            String Property = props.getProperty (key);
            System.out.println(key+Property);
        }
    }
    
	/*
	 * main entry for test
	 */
	public static void main(String[] args){
		System.out.println(System.getProperty("user.dir"));
		try {
			readProperties("S:/repository/tmp_client/conf/default.conf");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
    
    
}