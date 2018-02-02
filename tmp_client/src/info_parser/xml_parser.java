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

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import flow_control.task_enum;
import utility_funcs.time_info;

/*
 * This class used to get the basic information of the client.
 * 1: Memory 
 */
public class xml_parser {
	// public property
	// protected property
	// private property
	private static final Logger XML_PARSER_LOGGER = LogManager.getLogger(xml_parser.class.getName());
	// private String xml_path = null;

	// public function
	// protected function
	// private function
	public xml_parser() {
	}

	public String create_client_document_string(HashMap<String, String> xml_data) {
		Document document = DocumentHelper.createDocument();
		Element root_element = document.addElement("client");
		Set<String> xml_data_set = xml_data.keySet();
		Iterator<String> xml_data_it = xml_data_set.iterator();
		while (xml_data_it.hasNext()) {
			String key = xml_data_it.next();
			String value = xml_data.get(key);
			Element level2_element = root_element.addElement(key);
			level2_element.setText(value);
		}
		String text = document.asXML();
		return text;
	}

	public String create_result_document_string(
			HashMap<String, HashMap<String, Object>> xml_data, 
			String ip,
			String machine) {
		Document document = DocumentHelper.createDocument();
		Element root_element = document.addElement("CaseResults");
		root_element.addAttribute("ip", ip);
		root_element.addAttribute("machine", machine);
		Iterator<String> xml_data_it = xml_data.keySet().iterator();
		while (xml_data_it.hasNext()) {
			String level1_key = xml_data_it.next();
			HashMap<String, Object> level1_data = xml_data.get(level1_key);
			Element level1_element = root_element.addElement("case");
			Iterator<String> level1_data_it = xml_data.get(level1_key).keySet().iterator();
			while (level1_data_it.hasNext()) {
				String level2_key = level1_data_it.next();
				String level2_value = new String(); 
				if (level2_key.equals("status")){
					task_enum level2_temp = (task_enum) level1_data.get(level2_key);
					level2_value = level2_temp.get_description();
				} else {
					level2_value = (String) level1_data.get(level2_key);
				}
				level1_element.addElement(level2_key).addText(level2_value);
			}
		}
		String text = document.asXML();
		return text;
	}

	public String create_runtime_document_string(HashMap<String, HashMap<String, String>> xml_data) {
		Document document = DocumentHelper.createDocument();
		Element root_element = document.addElement("root");
		Set<String> xml_data_set = xml_data.keySet();
		Iterator<String> xml_data_it = xml_data_set.iterator();
		while (xml_data_it.hasNext()) {
			String level1_key = xml_data_it.next();
			HashMap<String, String> level1_data = xml_data.get(level1_key);
			Element level1_element = root_element.addElement("case");
			Iterator<String> level1_data_it = xml_data.get(level1_key).keySet().iterator();
			while (level1_data_it.hasNext()) {
				String level2_key = level1_data_it.next();
				String level2_value = level1_data.get(level2_key);
				level1_element.addElement(level2_key).addText(level2_value);
			}
		}
		String text = document.asXML();
		return text;
	}

	public static String document_to_string(Document document_obj) {
		String text = document_obj.asXML();
		return text;
	}

	public static Document string_to_document(String xml_string) throws DocumentException {
		Document document = DocumentHelper.parseText(xml_string);
		return document;
	}

	public static Map<String, HashMap<String, HashMap<String, String>>> get_rmq_xml_data(String xmlString) {
		xmlString = xmlString.replaceAll("\\s", " ");
		@SuppressWarnings("unused")
		String admin_queue = "<AdminQ title=\"Queue_30_20_1\">" + "<ID>" + "<Sub name=\"project\" value=\"**\"></Sub>"
				+ "<Sub name=\"run\" value=\"123\"></Sub>" + "</ID>" + " <System>"
				+ "<Sub name=\"os\" value=\"windows\"></Sub>" + "<Sub name=\"min_space\" value=\"**\"></Sub>"
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
		Document xml_doc = null;
		try {
			xml_doc = string_to_document(xmlString);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			XML_PARSER_LOGGER.warn("Wrong/empty xml format received, skip.");
			return level1_data;
		}
		Element root_node = xml_doc.getRootElement();
		if (root_node.attribute("title") == null) {
			return level1_data;
		}
		String title_name = root_node.attribute("title").getValue();
		HashMap<String, HashMap<String, String>> level2_data = new HashMap<String, HashMap<String, String>>();
		for (Iterator<?> i = root_node.elementIterator(); i.hasNext();) {
			Element level2_element = (Element) i.next();
			String element_name = level2_element.getName();
			HashMap<String, String> level3_data = new HashMap<String, String>();
			for (Iterator<?> j = level2_element.elementIterator(); j.hasNext();) {
				Element level3_element = (Element) j.next();
				String name_attr = level3_element.attributeValue("name");
				String value_attr = level3_element.attributeValue("value");
				if (name_attr == null) {
					continue;
				}
				level3_data.put(name_attr, value_attr);
			}
			level2_data.put(element_name, level3_data);
		}
		level1_data.put(title_name, level2_data);
		return level1_data;
	}

	// admin queue
	public Boolean dump_admin_data(
			HashMap<String, HashMap<String, String>> admin_queue_data,
			String queue_name, 
			String xml_path) throws IOException {
		Boolean dump_status = new Boolean(true);
		Document document = DocumentHelper.createDocument();
		Element root_element = document.addElement("root");
		root_element.addAttribute("time", time_info.get_date_time());
		Iterator<String> admin_queue_data_it = admin_queue_data.keySet().iterator();
		while (admin_queue_data_it.hasNext()) {
			String level2_key = admin_queue_data_it.next();
			HashMap<String, String> level2_data = admin_queue_data.get(level2_key);
			Element level2_element = root_element.addElement(level2_key);
			Iterator<String> level2_data_it = level2_data.keySet().iterator();
			while (level2_data_it.hasNext()) {
				String level3_key = level2_data_it.next();
				String level3_value = level2_data.get(level3_key);
				level2_element.addElement(level3_key).addText(level3_value);
			}
		}
		OutputFormat format = OutputFormat.createPrettyPrint();
		XMLWriter writer = new XMLWriter(new FileWriter(xml_path), format);
		writer.write(document);
		writer.flush();
		writer.close();
		return dump_status;
	}

	// task queue
	public Boolean dump_task_data(TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data,
			String queue_name, 
			String xml_path) throws IOException {
		Boolean dump_status = new Boolean(true);
		Document document = DocumentHelper.createDocument();
		Element root_element = document.addElement("root");
		root_element.addAttribute("time", time_info.get_date_time());
		Set<String> task_queue_data_set = task_queue_data.keySet();
		Iterator<String> task_queue_data_it = task_queue_data_set.iterator();
		while (task_queue_data_it.hasNext()) {
			String level2_key = task_queue_data_it.next();
			HashMap<String, HashMap<String, String>> level2_data = task_queue_data.get(level2_key);
			Element level2_element = root_element.addElement("case").addAttribute("name", level2_key);
			Iterator<String> level2_data_it = level2_data.keySet().iterator();
			while (level2_data_it.hasNext()) {
				String level3_key = level2_data_it.next();
				HashMap<String, String> level3_data = level2_data.get(level3_key);
				Element level3_element = level2_element.addElement(level3_key);
				Iterator<String> level3_data_it = level3_data.keySet().iterator();
				while (level3_data_it.hasNext()) {
					String level4_key = level3_data_it.next();
					String level4_value = level3_data.get(level4_key);
					level3_element.addElement(level4_key).addText(level4_value);
				}
			}
		}
		OutputFormat format = OutputFormat.createPrettyPrint();		
		XMLWriter writer = new XMLWriter(new FileWriter(xml_path), format);
		writer.write(document);
		writer.flush();
		writer.close();
		return dump_status;
	}

	public HashMap<String, HashMap<String, String>> get_xml_file_admin_queue_data(String xml_path)
			throws DocumentException {
		HashMap<String, HashMap<String, String>> admin_queue_data = new HashMap<String, HashMap<String, String>>();
		File xml_fobj = new File(xml_path);
		Long time = xml_fobj.lastModified();
		String time_modified = time_info.get_date_hhmm(new Date(time));
		SAXReader reader = new SAXReader();
		Document document = reader.read(xml_fobj);
		Element level1_element = document.getRootElement();
		String time_create = level1_element.attributeValue("time");
		if (!time_create.contains(time_modified)) {
			XML_PARSER_LOGGER.warn("xml modified outside, ignore:" + xml_path);
			return admin_queue_data;
		}
		for (Iterator<?> i = level1_element.elementIterator(); i.hasNext();) {
			Element level2_element = (Element) i.next();
			String level2_name = level2_element.getName();
			HashMap<String, String> level2_data = new HashMap<String, String>();
			for (Iterator<?> j = level2_element.elementIterator(); j.hasNext();) {
				Element level3_element = (Element) j.next();
				String level3_name = level3_element.getName();
				String level3_value = level3_element.getText();
				level2_data.put(level3_name, level3_value);
			}
			admin_queue_data.put(level2_name, level2_data);
		}
		return admin_queue_data;
	}
	
	public TreeMap<String, HashMap<String, HashMap<String, String>>> get_xml_file_task_queue_data(String xml_path)
			throws DocumentException {
		TreeMap<String, HashMap<String, HashMap<String, String>>> task_queue_data = new TreeMap<String, HashMap<String, HashMap<String, String>>>();
		File xml_fobj = new File(xml_path);
		Long time = xml_fobj.lastModified();
		String time_modified = time_info.get_date_hhmm(new Date(time));
		SAXReader reader = new SAXReader();
		Document document = reader.read(xml_fobj);
		Element level1_element = document.getRootElement();
		String time_create = level1_element.attributeValue("time");
		if (!time_create.contains(time_modified)) {
			XML_PARSER_LOGGER.warn("xml modified outside, ignore:" + xml_path);
			return task_queue_data;
		}
		for (Iterator<?> i = level1_element.elementIterator(); i.hasNext();) {
			Element level2_element = (Element) i.next();
			String case_name = level2_element.attributeValue("name");
			HashMap<String, HashMap<String, String>> level2_data = new HashMap<String, HashMap<String, String>>();
			for (Iterator<?> j = level2_element.elementIterator(); j.hasNext();) {
				Element level3_element = (Element) j.next();
				String level3_name = level3_element.getName();
				HashMap<String, String> level3_data = new HashMap<String, String>();
				for (Iterator<?> k = level3_element.elementIterator(); k.hasNext();) {
					Element level4_element = (Element) k.next();
					String key = level4_element.getName();
					String value = level4_element.getText();
					level3_data.put(key, value);
				}
				level2_data.put(level3_name, level3_data);
			}
			task_queue_data.put(case_name, level2_data);
		}
		return task_queue_data;
	}

	public static void main(String[] args) {
		xml_parser xml_parser2 = new xml_parser();
		HashMap<String, HashMap<String, String>> queue_data = new HashMap<String, HashMap<String, String>>();
		try {
			queue_data = xml_parser2.get_xml_file_admin_queue_data("D:/tmp_work_space/logs/retrieve/received_admin/511@run_997_041817_141406.xml");
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(queue_data.toString());
	}
	
	public static void main2(String[] args) {
		@SuppressWarnings("unused")
		xml_parser xml_parser2 = new xml_parser();
		HashMap<String, HashMap<String, String>> result_data = new HashMap<String, HashMap<String, String>>();
		HashMap<String, String> result_data1 = new HashMap<String, String>();
		result_data1.put("testId", "T123456");
		result_data1.put("runId", "111111");
		result_data1.put("result", "pass");
		HashMap<String, String> result_data2 = new HashMap<String, String>();
		result_data2.put("testId", "T654321");
		result_data2.put("runId", "222222");
		result_data2.put("result", "fail");
		result_data.put("T123456", result_data1);
		result_data.put("T654321", result_data2);
		System.out.println(result_data.toString());
	}
}