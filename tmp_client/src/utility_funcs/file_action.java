package utility_funcs;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.alibaba.fastjson.JSONObject;

/*
 * Functions for files
 */
public class file_action {
	private static final Logger FILE_ACTION_LOGGER = LogManager.getLogger(file_action.class.getName());
	private static List<String> key_file_list;
	
	public file_action() {

	}

	public static int write_file(String file_path, String file_content) {
		/*
		 * this function used to write the Contents to filename if the write
		 * action operated smoothly, 0 will be returned if the file exists, 1
		 * will be returned if something unknown happen, 2 will be returned
		 */
		File file = new File(file_path);
		if (file.exists())
			return 1;
		File file_parent = file.getParentFile();
		if (!(file_parent.isDirectory() && file_parent.exists())) {
			file_parent.mkdirs();
		}
		PrintWriter output;
		try {
			output = new PrintWriter(file);
			output.print(file_content);
			output.close();
			return 0;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			FILE_ACTION_LOGGER.warn("Write file exception:" + file_path);
			return 2;
		}
	}

	public static int force_write_file(String file_path, String file_content) {
		/*
		 * this function used to write the Contents to filename if the write
		 * action operated smoothly, 0 will be returned if the file exists, 1 will be returned
		 */
		File file = new File(file_path);
		if (file.exists())
			file.delete();
		File file_parent = file.getParentFile();
		if (!(file_parent.isDirectory() && file_parent.exists())) {
			file_parent.mkdirs();
		}
		PrintWriter output;
		try {
			output = new PrintWriter(file);
			output.print(file_content);
			output.close();
			return 0;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			FILE_ACTION_LOGGER.warn("Write file exception:" + file_path);
			return 1;
		}
	}
	
	public static void copy_file(String src_file, String dest_file) {
		File src = new File(src_file);
		File dest = new File(dest_file);
		try {
			FileUtils.copyFile(src, dest);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			FILE_ACTION_LOGGER.warn("Copy file exception:");
			FILE_ACTION_LOGGER.warn("Source:" + src_file);
			FILE_ACTION_LOGGER.warn("destination:" + dest_file);
		}
	}

	public static Boolean del_file(String file_path) {
		File delFile = new File(file_path);
		return FileUtils.deleteQuietly(delFile);
	}

	public static Boolean del_file_match_extension(
			String path,
			String ext
			) {
		File path_dobj = new File(path);
		FilenameFilter filter = new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				// TODO Auto-generated method stub
				File test_file = new File(dir, name);
				return test_file.isFile() && test_file.getName().endsWith(ext);
			}
		};
		if (!path_dobj.exists()) {
			FILE_ACTION_LOGGER.warn("Path doesn't exists:" + path);
			return false;
		}
		if (!path_dobj.canWrite()) {
			FILE_ACTION_LOGGER.warn("Path doesn't writeable:" + path);
			return false;
		}
		for(File file_obj:path_dobj.listFiles(filter)) {
			if(file_obj.canWrite()){
				file_obj.delete();
			} else {
				FILE_ACTION_LOGGER.warn("Delete file failed:" + file_obj.getAbsolutePath());
			}
		}
        return true;
	}
	
	public static Boolean del_file_match_expression(
			String path,
			String exp
			) {
		File path_dobj = new File(path);
		FilenameFilter filter = new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				// TODO Auto-generated method stub
				File test_file = new File(dir, name);
				return test_file.isFile() && test_file.getName().contains(exp);
			}
		};
		if (!path_dobj.exists()) {
			FILE_ACTION_LOGGER.warn("Path doesn't exists:" + path);
			return false;
		}
		if (!path_dobj.canWrite()) {
			FILE_ACTION_LOGGER.warn("Path doesn't writeable:" + path);
			return false;
		}
		for(File file_obj:path_dobj.listFiles(filter)) {
			if(file_obj.canWrite()){
				file_obj.delete();
			} else {
				FILE_ACTION_LOGGER.warn("Delete file failed:" + file_obj.getAbsolutePath());
			}
		}
        return true;
	}
	
	public static int append_file(String file, String conent) {
		/*
		 * If the file size larger than 2M, a new file will be created true: 0
		 * will be return false: 1 will be return
		 */
		BufferedWriter out = null;
		File file_hand = new File(file);
		if (file_hand.exists() && file_hand.isFile()) {
			if (file_hand.length() < 2 * 1000000) {
				;
			} else {
				String temp_file = file + System.currentTimeMillis() / 1000;
				copy_file(file, temp_file);
				del_file(file);
			}
		}
		try {
			File file_parent = file_hand.getParentFile();
			if (file_parent.isDirectory() && file_parent.exists())
				;
			else
				file_parent.mkdirs();
			out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));
			out.write(conent);
			out.close();
			return 0;
		} catch (Exception e) {
			FILE_ACTION_LOGGER.warn("Append Error:" + file);
			return 1;
		}
	}

	public static int append_file_with_title(
			String file, 
			String title,
			String conent) {
		/*
		 * If the file size larger than 2M, a new file will be created true: 0
		 * will be return false: 1 will be return
		 */
		Boolean new_file = Boolean.valueOf(false);
		BufferedWriter out = null;
		File file_hand = new File(file);
		if (file_hand.exists() && file_hand.isFile()) {
			if (file_hand.length() < 2 * 1000000) {
				new_file = false;
			} else {
				String temp_file = file + System.currentTimeMillis() / 1000;
				copy_file(file, temp_file);
				del_file(file);
				new_file = true;
			}
		} else {
			new_file = true;
		}
		try {
			File file_parent = file_hand.getParentFile();
			if (file_parent.isDirectory() && file_parent.exists())
				;
			else
				file_parent.mkdirs();
			out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));
			if (new_file) {
				out.write(title + System.getProperty("line.separator"));
			}
			out.write(conent);
			out.close();
			return 0;
		} catch (Exception e) {
			FILE_ACTION_LOGGER.warn("Append Error:" + file);
			return 1;
		}
	}
	
	public static String read_file(String filename) {
		File file = new File(filename);
		Scanner input;
		try {
			input = new Scanner(file);
			String content = "";
			while (input.hasNext()) {
				content += input.next();
			}
			input.close();
			return content;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			return "Error:0";
		}
	}

	public static List<String> read_file_lines(String filename) {
		List<String> file_lines = new ArrayList<String>();
		File file = new File(filename);
		if(!file.exists()){
			return file_lines;
		}
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
			String s = null;
			while((s = br.readLine())!=null){
				s = s.trim();
				if(s.equals("")){
					continue;
				}
				file_lines.add(s);
			}
			br.close();			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return file_lines;
	}
	
	public static int delete_file(String filename) {
		File file = new File(filename);
		try {
			file.delete();
			return 0;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 1;
		}
	}

	public static void unzipFolder(String zipPath, String unzipPath) {
		File zipFile = new File(zipPath);
		try {
			BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(zipFile));
			ArchiveInputStream in = new ArchiveStreamFactory().createArchiveInputStream(ArchiveStreamFactory.ZIP,
					bufferedInputStream);
			ZipArchiveEntry entry = null;
			while ((entry = (ZipArchiveEntry) in.getNextEntry()) != null) {
				if (entry.isDirectory()) {
					new File(unzipPath, entry.getName()).mkdir();
				} else {
					OutputStream out = FileUtils.openOutputStream(new File(unzipPath, entry.getName()));
					IOUtils.copy(in, out);
					out.close();
				}
			}
			in.close();
		} catch (FileNotFoundException e) {
			FILE_ACTION_LOGGER.error("Cannot find file");
		} catch (ArchiveException e) {
			FILE_ACTION_LOGGER.error("Format not support, support zip format");
		} catch (IOException e) {
			FILE_ACTION_LOGGER.error("IO exception in file generation");
		}
	}

	public static void zipFolder(String zipDir, String destFile) {
		File outFile = new File(destFile);
		try {
			outFile.createNewFile();
			BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(outFile));
			ArchiveOutputStream out = new ArchiveStreamFactory().createArchiveOutputStream(ArchiveStreamFactory.JAR,
					bufferedOutputStream);
			if (zipDir.charAt(zipDir.length() - 1) != '/') {
				zipDir += '/';
			}
			Iterator<File> files = FileUtils.iterateFiles(new File(zipDir), null, true);
			while (files.hasNext()) {
				File file = files.next();
				String file_path = file.getPath().replace("\\", "/"); // for windows
				String entry_name = file_path.replace(zipDir, "");
				ZipArchiveEntry zipArchiveEntry = new ZipArchiveEntry(file, entry_name);
				out.putArchiveEntry(zipArchiveEntry);
				IOUtils.copy(new FileInputStream(file), out);
				out.closeArchiveEntry();
			}
			out.finish();
			out.close();
		} catch (IOException e) {
			FILE_ACTION_LOGGER.error("Failed generate the file:" + outFile.toString());
		} catch (ArchiveException e) {
			FILE_ACTION_LOGGER.error("Archive format not support");
		}
	}

	public static List<String> get_key_file_list(String top_path, String key_pattern) {
		key_file_list = new ArrayList<String>();
		File top_path_obj = new File(top_path);
		if (!top_path_obj.exists()){
			return key_file_list;
		}
		scan_directory(top_path_obj, key_pattern);
		return key_file_list;
	}
	
	public static void scan_directory(File file, String key_pattern) {
		File flist[] = file.listFiles();
		if (flist == null || flist.length == 0) {
		    return;
		}
		Pattern pattern = Pattern.compile(key_pattern);
		for (File f : flist){
			if (f.isDirectory()) { 
		        scan_directory(f, key_pattern);				
			} else {
				String file_name = f.getName();
				Matcher key_match = pattern.matcher(file_name);
				if (key_match.find()){
					key_file_list.add(f.getAbsolutePath().replaceAll("\\\\", "/"));
					break;
				}
			}
		}
	}
	
	public static List<String> get_key_path_list(String top_path, String key_pattern) {
		key_file_list = new ArrayList<String>();
		File top_path_obj = new File(top_path);
		if (!top_path_obj.exists()){
			return key_file_list;
		}
		scan_directory2(top_path_obj, key_pattern);
		return key_file_list;
	}
	
	public static void scan_directory2(File file, String key_pattern) {
		File flist[] = file.listFiles();
		if (flist == null || flist.length == 0) {
		    return;
		}
		Pattern pattern = Pattern.compile(key_pattern);
		for (File f : flist){
			if (f.isDirectory()) { 
				scan_directory2(f, key_pattern);				
			} else {
				String file_name = f.getName();
				Matcher key_match = pattern.matcher(file_name);
				if (key_match.find()){
					key_file_list.add(f.getAbsoluteFile().getParent().replaceAll("\\\\", "/"));
					break;
				}
			}
		}
	}	
	
	public static Boolean lock_file_waiting(String file_path){
		Boolean status = Boolean.valueOf(false);
		File lock_file = new File(file_path);
		int counter = 0;
		while (lock_file.exists()){
			counter += 1;
			if (counter > 20){
				break;
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (lock_file.exists()){
			status = false;
		} else {
			status = true;
		}
		return status;
	}
	
	public static Boolean gen_lock_file(String file_path){
		Boolean status = Boolean.valueOf(false);
		File lock_file = new File(file_path);
		int counter = 0;
		while (lock_file.exists()){
			counter += 1;
			if (counter > 20){
				break;
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (lock_file.exists()){
			status = false;
		} else {
			file_action.write_file(file_path, time_info.get_date_time());
			status = true;
		}
		return status;
	}
	
	public static Map<String,Object> get_json_map_data(String file_path) {
		File jfile = new File(file_path);
		String json_str = new String("");
		Map<String,Object> map_data = new HashMap<String,Object>();
		if (!jfile.exists()){
			return map_data;
		}
		try {
			json_str = FileUtils.readFileToString(jfile, "UTF-8");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			FILE_ACTION_LOGGER.error("Read json file failed");
			return map_data;
		}
		map_data = (Map<String,Object>)JSONObject.parseObject(json_str);
		return map_data;
	}
	
	public static Boolean del_lock_file(String file_path) {
		File delFile = new File(file_path);
		return FileUtils.deleteQuietly(delFile);
	}
	
	public static Boolean is_path_same(
			String file_path1,
			String file_path2
			) throws IOException {
		File File1 = new File(file_path1);
		File File2 = new File(file_path2);
		if (File1.getCanonicalPath().equalsIgnoreCase(File2.getCanonicalPath())) {
			return true;
		} else {
			return false;
		}
		
	}
	
	public static String get_absolute_paths(
			String raw_paths){
		String [] path_list = raw_paths.split("\\s*,\\s*");
		ArrayList<String> return_list = new ArrayList<String>();
		for (String path: path_list){
			if (path.contains("$")){
				//Special path variable inside skip convert
				return_list.add(path);
				continue;
			}
			File raw_file = new File(path);
			String raw_path = new String(raw_file.getAbsolutePath().replaceAll("\\\\", "/"));
			return_list.add(raw_path.replaceAll("/\\.", ""));
		}
		return String.join(",", return_list);
	}
	
	public static void main1(String[] args) {
		//System.out.println(get_key_path_list("C:/Users/jwang1/Desktop/eit_run/demo_suite/user_suite", "run_par.py").toString());
		String work_dir = System.getProperty("user.dir");
		System.out.println(work_dir);
		try {
			if (is_path_same("G:/repository/TMP_client", ".")) {
				System.out.println("same");
			} else {
				System.out.println("not same");
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		del_file_match_extension("C:/Users/jwang1/Desktop/T22356061", ".csv");
	}
}
