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
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

import org.apache.commons.configuration2.*;
import org.apache.commons.configuration2.ex.ConfigurationException;

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
    public static void readProperties(String file_path) throws FileNotFoundException{
    	INIConfiguration iniConfiguration = new INIConfiguration();
    	System.out.println(file_path);
    	try {
			iniConfiguration.read(new FileReader(file_path));
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
    	Iterator<String> key_iterator = iniConfiguration.getKeys();
    	while(key_iterator.hasNext()){
    		System.out.println(key_iterator.next());
    	}
    }
    
	public static void main(String[] args){
		System.out.println("haha");
	}
    
}