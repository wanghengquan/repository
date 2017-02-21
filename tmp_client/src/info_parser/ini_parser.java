/*
 * File: ini_parser.java
 * Description: Software configure parser definition
 * Author: Jason.Wang
 * Date:2017/02/15
 * Modifier:
 * Date:
 * Description:
 */
package info_parser;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.configuration2.INIConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.builder.fluent.Parameters;
import org.apache.commons.configuration2.ex.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/*
 * PlatUML graph
 * @startuml
 * :Hello world;
 * :This is on defined on
 * several **lines**;
 * @enduml
 */
public class ini_parser {
	// public property
	// protect property
	// private property
	private static final Logger CFG_LOGGER = LogManager.getLogger(ini_parser.class.getName());
	private String cfg_path = null;

	public ini_parser(String file_path) {
		this.cfg_path = file_path;
	}
	// public function
	// protect function
	// private function

	/*
	 * build ini_builder
	 * 
	 * @input String file_path
	 * 
	 * @return INIConfiguration
	 */
	private FileBasedConfigurationBuilder<INIConfiguration> get_ini_builder() {
		Parameters params = new Parameters();
		FileBasedConfigurationBuilder<INIConfiguration> builder = new FileBasedConfigurationBuilder<INIConfiguration>(
				INIConfiguration.class).configure(params.hierarchical().setFileName(cfg_path));
		return builder;
	}

	/*
	 * get ini_config
	 * 
	 * @input String file_path
	 * 
	 * @return INIConfiguration
	 */
	private INIConfiguration get_ini_confg(FileBasedConfigurationBuilder<INIConfiguration> builder)
			throws ConfigurationException {
		INIConfiguration ini_config = builder.getConfiguration();
		return ini_config;
	}

	/*
	 * read sections
	 * 
	 * @input String file_path
	 * 
	 * @return Set<String>
	 */
	@SuppressWarnings("unused")
	private Set<String> read_ini_sections() throws ConfigurationException {
		Parameters params = new Parameters();
		FileBasedConfigurationBuilder<INIConfiguration> builder = new FileBasedConfigurationBuilder<INIConfiguration>(
				INIConfiguration.class).configure(params.hierarchical().setFileName(cfg_path));
		INIConfiguration ini_config = builder.getConfiguration();
		Set<String> sections = ini_config.getSections();
		return sections;
	}

	/*
	 * read sections
	 * 
	 * @input INIConfiguration ini_config
	 * 
	 * @return Set<String>
	 */
	private Set<String> read_ini_sections(INIConfiguration ini_config) {
		Set<String> sections = ini_config.getSections();
		return sections;
	}

	/*
	 * read properties
	 * 
	 * @input INIConfiguration ini_config
	 * 
	 * @input String section
	 * 
	 * @return Set<String>
	 */
	@SuppressWarnings("unused")
	private Properties read_ini_properties(INIConfiguration ini_config, String section) {
		Properties section_properties = ini_config.getProperties(section);
		return section_properties;
	}

	/*
	 * read key
	 * 
	 * @input INIConfiguration ini_config
	 * 
	 * @input String key
	 * 
	 * @return Set<String>
	 */
	public String read_ini_property(INIConfiguration ini_config, String section, String option) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		String value = (String) ini_config.getProperty(key);
		return value;
	}

	/*
	 * add key
	 * 
	 * @input INIConfiguration ini_config
	 * 
	 * @input String section
	 * 
	 * @input String option
	 * 
	 * @input String value
	 * 
	 * @return Set<String>
	 */
	private int add_ini_property(INIConfiguration ini_config, String section, String option, String value) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (ini_config.containsKey(key)) {
			CFG_LOGGER.warn("Config file " + key + " already exists, skipped.");
			return 1;
		}
		ini_config.addProperty(key, value);
		return 0;
	}

	/*
	 * delete key
	 * 
	 * @input INIConfiguration ini_config
	 * 
	 * @input String section
	 * 
	 * @input String option
	 * 
	 * @input String value
	 * 
	 * @return Set<String>
	 */
	@SuppressWarnings("unused")
	private int del_ini_property(INIConfiguration ini_config, String section, String option) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (ini_config.containsKey(key)) {
			ini_config.clearProperty(key);
			;
			return 0;
		} else {
			CFG_LOGGER.warn("Config file " + key + " not exists, skipped.");
			return 1;
		}
	}

	/*
	 * set key
	 * 
	 * @input INIConfiguration ini_config
	 * 
	 * @input String section
	 * 
	 * @input String option
	 * 
	 * @input String value
	 * 
	 * @return Set<String>
	 */
	@SuppressWarnings("unused")
	private int set_ini_property(INIConfiguration ini_config, String section, String option, String value) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (ini_config.containsKey(key)) {
			ini_config.setProperty(key, value);
		} else {
			CFG_LOGGER.warn("Config file " + key + " not exists, skipped.");
			return 1;
		}
		return 0;
	}

	public HashMap<String, HashMap<String, String>> read_ini_data() throws ConfigurationException{
		HashMap<String, HashMap<String, String>> ini_data = new HashMap<String, HashMap<String, String>>();
		FileBasedConfigurationBuilder<INIConfiguration> builder = get_ini_builder();
		INIConfiguration configure = get_ini_confg(builder);
		Set<String> sections = read_ini_sections(configure);
		Iterator<String> sections_it = sections.iterator();
		while(sections_it.hasNext()){
			String section = sections_it.next();
			HashMap<String, String> section_data = new HashMap<String, String>();
			Iterator<String> keys_it = configure.getKeys(section + ".");
			while(keys_it.hasNext()){
				String key = keys_it.next();
				String option = key.replace(section + ".", "").replaceAll("\\.\\.", ".");
				String value = (String) configure.getProperty(key);
				section_data.put(option, value);
			}
			ini_data.put(section, section_data);
		}
		return ini_data;
	}
	
	public void write_ini_data(HashMap<String, HashMap<String, String>> write_data) throws ConfigurationException{
		FileBasedConfigurationBuilder<INIConfiguration> builder = get_ini_builder();
		INIConfiguration configure = get_ini_confg(builder);
		//remove previous key sets
		Iterator<String> key_it = configure.getKeys();
		while(key_it.hasNext()){
			String key = key_it.next();
			configure.clearProperty(key);
		}
		//add new key set form map data
		Set<String> section_set = write_data.keySet();
		TreeSet<String> tree_section = new TreeSet<String>();
		tree_section.addAll(section_set);
		Iterator<String> section_it = tree_section.iterator();
		while(section_it.hasNext()){
			String section = section_it.next();
			Set<String> option_set = write_data.get(section).keySet();
			TreeSet<String> tree_option = new TreeSet<String>();
			tree_option.addAll(option_set);
			Iterator<String> option_it = tree_option.iterator();
			while(option_it.hasNext()){
				String option = option_it.next();
				String value = write_data.get(section).get(option);
				add_ini_property(configure, section, option, value);
			}
		}
		//save configuration
		builder.save();
	}
	
	public static void main(String[] args) {
		ini_parser ini_parser2 = new ini_parser("conf/default.conf");
		HashMap<String, HashMap<String, String>> read_data = null;
		try {
			read_data= ini_parser2.read_ini_data();
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		HashMap<String, String> section_data= read_data.get("tmp_base");
		section_data.put("test2.10", "123");
		read_data.put("tmp_base", section_data);
		try {
			ini_parser2.write_ini_data(read_data);
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(read_data.toString());
		System.out.println(read_data.get("diamond").containsKey("scan_dir"));
	}
}