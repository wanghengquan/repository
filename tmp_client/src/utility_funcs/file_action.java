package utility_funcs;

import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

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
			FILE_ACTION_LOGGER.warn("Write file exception");
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
			FILE_ACTION_LOGGER.warn("Write file exception");
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
			FILE_ACTION_LOGGER.warn("Copy file exception");
		}
	}

	public static Boolean del_file(String file_path) {
		File delFile = new File(file_path);
		return FileUtils.deleteQuietly(delFile);
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
			FILE_ACTION_LOGGER.warn("Append file error");
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

	public static List<String> get_key_file_list(String top_path, String key_file) {
		key_file_list = new ArrayList<String>();
		File top_path_obj = new File(top_path);
		if (!top_path_obj.exists()){
			return key_file_list;
		}
		scan_directory(top_path_obj, key_file);
		return key_file_list;
	}
	
	public static void scan_directory(File file, String key_file) {
		File flist[] = file.listFiles();
		if (flist == null || flist.length == 0) {
		    return;
		}
		for (File f : flist){
			if (f.isDirectory()) { 
		        scan_directory(f, key_file);				
			} else {
				String file_name = f.getName();
				if (file_name.equalsIgnoreCase(key_file)){
					key_file_list.add(f.getAbsolutePath().replaceAll("\\\\", "/"));
				}
			}
		}
	}
	
	public static List<String> get_key_path_list(String top_path, String key_file) {
		key_file_list = new ArrayList<String>();
		File top_path_obj = new File(top_path);
		if (!top_path_obj.exists()){
			return key_file_list;
		}
		scan_directory2(top_path_obj, key_file);
		return key_file_list;
	}
	
	public static void scan_directory2(File file, String key_file) {
		File flist[] = file.listFiles();
		if (flist == null || flist.length == 0) {
		    return;
		}
		for (File f : flist){
			if (f.isDirectory()) { 
				scan_directory2(f, key_file);				
			} else {
				String file_name = f.getName();
				if (file_name.equalsIgnoreCase(key_file)){
					key_file_list.add(f.getAbsoluteFile().getParent().replaceAll("\\\\", "/"));
				}
			}
		}
	}	
	
	public static void main(String[] args) {
		System.out.println(get_key_path_list("C:/Users/jwang1/Desktop/eit_run/demo_suite/user_suite", "run_par.py").toString());
	}	
	
	public static void main2(String[] args) {
		String work_dir = System.getProperty("user.dir");
		System.out.println(work_dir);
		String init_content = "AAAA" + System.lineSeparator() + "BBBB" + System.lineSeparator();
		System.out.println("write file:");
		file_action.write_file("./lab.txt", init_content);
		System.out.println("read after write:");
		String read_content = file_action.read_file("lab.txt");
		System.out.println(read_content);
		System.out.println("append file:");
		file_action.append_file("./lab.txt", "CCCC");
		System.out.println("read file after append:");
		read_content = file_action.read_file("lab.txt");
		System.out.println(read_content);
		System.out.println(file_action.delete_file("lab.txt"));
		
	}
}
