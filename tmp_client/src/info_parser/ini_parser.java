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

import java.util.Properties;
import java.util.Set;

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
class ini_parser {

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
	public FileBasedConfigurationBuilder<INIConfiguration> get_ini_builder() {
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
	public INIConfiguration get_ini_confg(FileBasedConfigurationBuilder<INIConfiguration> builder)
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
	public Set<String> read_ini_sections() throws ConfigurationException {
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
	public Set<String> read_ini_sections(INIConfiguration ini_config) {
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
	public Properties read_ini_properties(INIConfiguration ini_config, String section) {
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
	public int add_ini_property(INIConfiguration ini_config, String section, String option, String value) {
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
	public int del_ini_property(INIConfiguration ini_config, String section, String option) {
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
	public int set_ini_property(INIConfiguration ini_config, String section, String option, String value) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (ini_config.containsKey(key)) {
			ini_config.setProperty(key, value);
		} else {
			CFG_LOGGER.warn("Config file " + key + " not exists, skipped.");
			return 1;
		}
		return 0;
	}

	/*
	 * save build
	 * 
	 * @input String file_path
	 * 
	 * @return INIConfiguration
	 */
	public void save_ini_builder(FileBasedConfigurationBuilder<INIConfiguration> builder)
			throws ConfigurationException {
		builder.save();
	}

	public static void main(String[] args) {
		ini_parser ini_parser2 = new ini_parser("conf/default.conf");
		FileBasedConfigurationBuilder<INIConfiguration> ini_builder = ini_parser2.get_ini_builder();
		INIConfiguration ini_config = new INIConfiguration();
		try {
			ini_config = ini_parser2.get_ini_confg(ini_builder);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		@SuppressWarnings("unused")
		Set<String> sections = ini_parser2.read_ini_sections(ini_config);
		ini_parser2.add_ini_property(ini_config, "base", "test", "test1");
		ini_parser2.set_ini_property(ini_config, "base", "rmq_host", "lsh-opera");
		try {
			ini_parser2.save_ini_builder(ini_builder);
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}