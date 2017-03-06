/*
 * File: xml_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/16
 * Modifier:
 * Date:
 * Description:
 */
package info_parser;

import java.io.StringReader;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import org.apache.commons.configuration2.XMLConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.builder.fluent.Parameters;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/*
 * This class used to get the basic information of the client.
 * 1: Memory 
 */
public class xml_parser {
	// public property
	// protected property
	// private property
	private static final Logger XML_LOGGER = LogManager.getLogger(xml_parser.class.getName());
	private String xml_path = null;

	// public function
	// protected function
	// private function
	public xml_parser(String file_path) {
		this.xml_path = file_path;
	}

	/*
	 * build ini_builder
	 * 
	 * @input String file_path
	 * 
	 * @return XMLConfiguration
	 */
	private FileBasedConfigurationBuilder<XMLConfiguration> get_xml_builder() {
		Parameters params = new Parameters();
		FileBasedConfigurationBuilder<XMLConfiguration> builder = new FileBasedConfigurationBuilder<XMLConfiguration>(
				XMLConfiguration.class).configure(params.xml().setFileName(xml_path));
		return builder;
	}

	/*
	 * get xml_config
	 * 
	 * @input String file_path
	 * 
	 * @return XMLConfiguration
	 */
	private XMLConfiguration get_xml_confg(FileBasedConfigurationBuilder<XMLConfiguration> builder)
			throws ConfigurationException {
		XMLConfiguration xml_config = builder.getConfiguration();
		return xml_config;
	}

	/*
	 * read properties
	 * 
	 * @input XMLConfiguration xml_config
	 * 
	 * @input String section
	 * 
	 * @return Set<String>
	 */
	@SuppressWarnings("unused")
	private Properties read_xml_properties(XMLConfiguration xml_config, String section) {
		Properties section_properties = xml_config.getProperties(section);
		return section_properties;
	}

	/*
	 * read key
	 * 
	 * @input XMLConfiguration xml_config
	 * 
	 * @input String key
	 * 
	 * @return Set<String>
	 */
	public String read_xml_property(XMLConfiguration xml_config, String section, String option) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		String value = (String) xml_config.getProperty(key);
		return value;
	}

	/*
	 * add key
	 * 
	 * @input XMLConfiguration xml_config
	 * 
	 * @input String section
	 * 
	 * @input String option
	 * 
	 * @input String value
	 * 
	 * @return Set<String>
	 */
	private int add_xml_property(XMLConfiguration xml_config, String section, String option, String value) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (xml_config.containsKey(key)) {
			XML_LOGGER.warn("Config file " + key + " already exists, skipped.");
			return 1;
		}
		xml_config.addProperty(key, value);
		return 0;
	}

	/*
	 * delete key
	 * 
	 * @input XMLConfiguration xml_config
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
	private int del_xml_property(XMLConfiguration xml_config, String section, String option) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (xml_config.containsKey(key)) {
			xml_config.clearProperty(key);
			;
			return 0;
		} else {
			XML_LOGGER.warn("Config file " + key + " not exists, skipped.");
			return 1;
		}
	}

	/*
	 * set key
	 * 
	 * @input XMLConfiguration xml_config
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
	private int set_xml_property(XMLConfiguration xml_config, String section, String option, String value) {
		String key = section.replaceAll("\\.", "..") + "." + option.replaceAll("\\.", "..");
		if (xml_config.containsKey(key)) {
			xml_config.setProperty(key, value);
		} else {
			XML_LOGGER.warn("Config file " + key + " not exists, skipped.");
			return 1;
		}
		return 0;
	}

	public HashMap<String, String> read_xml_data() throws ConfigurationException {
		HashMap<String, String> xml_data = new HashMap<String, String>();
		FileBasedConfigurationBuilder<XMLConfiguration> builder = get_xml_builder();
		XMLConfiguration configure = get_xml_confg(builder);
		Iterator<String> key_it = configure.getKeys();
		while (key_it.hasNext()) {
			String key = key_it.next();
			String value = (String) configure.getProperty(key).toString();
			xml_data.put(key, value);
		}
		return xml_data;
	}

	public void write_xml_data(HashMap<String, HashMap<String, String>> write_data) throws ConfigurationException {
		FileBasedConfigurationBuilder<XMLConfiguration> builder = get_xml_builder();
		XMLConfiguration configure = get_xml_confg(builder);
		// remove previous key sets
		Iterator<String> key_it = configure.getKeys();
		while (key_it.hasNext()) {
			String key = key_it.next();
			configure.clearProperty(key);
		}
		// add new key set form map data
		Set<String> section_set = write_data.keySet();
		TreeSet<String> tree_section = new TreeSet<String>();
		tree_section.addAll(section_set);
		Iterator<String> section_it = tree_section.iterator();
		while (section_it.hasNext()) {
			String section = section_it.next();
			Set<String> option_set = write_data.get(section).keySet();
			TreeSet<String> tree_option = new TreeSet<String>();
			tree_option.addAll(option_set);
			Iterator<String> option_it = tree_option.iterator();
			while (option_it.hasNext()) {
				String option = option_it.next();
				String value = write_data.get(section).get(option);
				add_xml_property(configure, section, option, value);
			}
		}
		// save configuration
		builder.save();
	}

	public static Map<String, HashMap<String, HashMap<String, String>>> parser_xml_string(String xmlString) {
		xmlString = xmlString.replaceAll("\\s", " ");
		// ArrayList <HashMap,String> adminMessage;
		@SuppressWarnings("unused")
		String admin_queue = "<AdminQ title=\"Queue_30_20_1\">" + "<ID>" + "<Sub name=\"project\" value=\"**\"></Sub>"
				+ "<Sub name=\"run\" value=\"**\"></Sub>" + "</ID>" + " <System>"
				+ "<Sub name=\"os\" value=\"**\"></Sub>" + "<Sub name=\"min_space\" value=\"**\"></Sub>"
				+ "<Sub name=\"min_cpu\" value=\"**\"></Sub>" + "<Sub name=\"min_mem\" value=\"**\"></Sub>"
				+ "</System>" + "</AdminQ>";
		@SuppressWarnings("unused")
		String task_queue = "<Test title=\"case_title\">" + "<TestID>" + "<Sub name=\"id\" value=\"34\"></Sub>"
				+ "</TestID>" + "<CaseInfo >"
				+ "<Sub name=\"repository\" value=\"http://linux12v/Diamond/trunk\"></Sub>"
				+ "<Sub name=\"suite_directory\" value=\"FE12v/snow_test\"></Sub>"
				+ "<Sub name=\"case_name\" value=\"40_dpc\"></Sub>" + "</CaseInfo>" + "<Environment>"
				+ "<Sub name=\"foundry\" value=\"c:/lscc/diamond/3.6_x64/ispfpga\"></Sub>"
				+ "<Sub name=\"LM_LICENSE_FILE\" value=\"27000@lsh-prince\"></Sub>" + "</Environment>"
				+ "<LaunchCommand>" + "<Sub name=\"cmd\" value=\"python trunk/bin/run_lattice.py --till-map\"></Sub>"
				+ "</LaunchCommand>" + "</Test>";
		Map<String, HashMap<String, HashMap<String, String>>> level1_data = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(new InputSource(new StringReader(xmlString)));
			Element root_node = doc.getDocumentElement();
			if (!root_node.hasAttribute("title")) {
				return level1_data;
			}
			String title_name = root_node.getAttribute("title");
			NodeList level2_nodes = root_node.getChildNodes();
			HashMap<String, HashMap<String, String>> level2_data = new HashMap<String, HashMap<String, String>>();
			for (int i = 0; i < level2_nodes.getLength(); i++) {
				Node level2_node = level2_nodes.item(i);
				String level2_node_name = level2_node.getNodeName();
				if (level2_node_name.equals("#text")) {
					continue;
				}
				HashMap<String, String> level3_data = new HashMap<String, String>();
				NodeList level3_nodes = level2_node.getChildNodes();
				for (int j = 0; j < level3_nodes.getLength(); j++) {
					Node level3_node = level3_nodes.item(j);
					NamedNodeMap level3_atts = level3_node.getAttributes();
					if (level3_atts == null) {
						continue;
					}
					String node_name = new String();
					String node_value = new String();
					for (int k = 0; k < level3_atts.getLength(); k++) {
						String temp_key = level3_atts.item(k).getNodeName();
						String temp_val = level3_atts.item(k).getNodeValue();
						if (temp_key.equals("name")) {
							node_name = temp_val;
						}
						if (temp_key.equals("value")) {
							node_value = temp_val;
						}
					}
					if (node_name != null && node_value != null) {
						level3_data.put(node_name, node_value);
					}
				}
				level2_data.put(level2_node_name, level3_data);
			}
			level1_data.put(title_name, level2_data);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return level1_data;
	}

	public static void main(String[] args) {
		xml_parser xml_parser2 = new xml_parser("D:/java_dev/result.xml");
		HashMap<String, HashMap<String, String>> write_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> result_data = new HashMap<String, String>();
		result_data.put("result", "pass");
		result_data.put("id", "123456");
		result_data.put("build", "12.05");
		write_data.put("T123456", result_data);
		try {
			xml_parser2.write_xml_data(write_data);
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		HashMap<String, String> read_data = new HashMap<String, String>();
		try {
			read_data = xml_parser2.read_xml_data();
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(read_data.toString());
	}
}