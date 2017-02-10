package utility_funcs;


import java.io.*;
import java.util.Iterator;
import java.util.Scanner;

import org.apache.commons.compress.archivers.ArchiveException;  
import org.apache.commons.compress.archivers.ArchiveInputStream;  
import org.apache.commons.compress.archivers.ArchiveOutputStream;  
import org.apache.commons.compress.archivers.ArchiveStreamFactory;  
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;  
import org.apache.commons.compress.utils.IOUtils;  
import org.apache.commons.io.FileUtils; 


public class file_action {
	
	public static int write_file(String filename, String fileContent){
		/**
		 * this function used to write the fileContent to filename
		 * if the write action operated smoothly, 0 will be returned
		 * if the file exists, 1 will be returned
		 * if something unknown happen, 2 will be returned
		 */
		File file = new File(filename);
		if (file.exists())
			return 1; 
		else{
			File file_parent = file.getParentFile();
    		if(file_parent.isDirectory() && file_parent.exists())
    			;
    		else
    			file_parent.mkdirs();
			PrintWriter output;
			try {
				output = new PrintWriter(file);
				output.print(fileContent);
				output.close();
				return 0; 
			} 
			catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return 2;
			}
		}
	}
	
	public static void copy_file(String src_file, String dest_file) {
        try {
            FileInputStream in = new FileInputStream(src_file);
            FileOutputStream out = new FileOutputStream(dest_file);
            int len;
            byte buffer[] = new byte[1024];
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            out.flush();
            out.close();
            in.close();
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    public static void del_file(String fileName) {
        try {
            String filePath = fileName;
            File delFile = new File(filePath);
            delFile.delete();
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
	public static int append_file(String file, String conent) {
		/*
		 * If the file size larger than 2M, a new file will be created
		 * true: 0 will be return
		 * false: 1 will be return
		 */
        BufferedWriter out = null;
        File file_hand= new File(file);  
        if (file_hand.exists() && file_hand.isFile()){
        	if(file_hand.length() < 2*1000000){
        		;
        	}
        	else{
        		String temp_file = file + System.currentTimeMillis() / 1000;
        		copy_file(file,temp_file);
        		del_file(file);
        	}
        }  
        try {
        	File file_parent = file_hand.getParentFile();
    		if(file_parent.isDirectory() && file_parent.exists())
    			;
    		else
    			file_parent.mkdirs();
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));     
            out.write(conent);
            out.close();     
            return 0;
        } catch (Exception e) {     
        	System.out.println(">>>Warning: append file error");
        	if(TopRun.dug_model){
        		e.printStackTrace();
        	}
            return 1;
        }  
    }
	
	public static int local_rpt(String file, String conent) throws IOException {
		/*
		 * If the file size larger than 2M, a new file will be created
		 * true: 0 will be return
		 * false: 1 will be return
		 */
        BufferedWriter out =null;
        File file_hand= new File(file);  
        if (file_hand.exists() && file_hand.isFile()){
        	out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));
        	 out.write(conent + publicData.line_separator);
        	 out.close();
        } else {
        	out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));
    		out.write("Case, Prj, Run, Design, Status, Reason" + publicData.line_separator);
            out.write(conent + publicData.line_separator);
            out.close();     
        }	
        return 0;
	}
	
	public static String read_file(String filename){
		File file = new File(filename);
		Scanner input;
		try {
			input = new Scanner(file);
			String content = "";
			while(input.hasNext()){
				content += input.next();
			}
			input.close();
			return content;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			return "Error:0";
		}
	}
	
    public static int delete_file(String filename){
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
    
    public static void print_out_to_file_to_gui(String content){
    	System.out.println(content);
    	append_file("log/client.log", content + System.lineSeparator());
    	}
    
	public static void unzipFolder(String zipPath, String unzipPath) {
		File zipFile = new File(zipPath);
		try {
			BufferedInputStream bufferedInputStream = new BufferedInputStream(
					new FileInputStream(zipFile));
			ArchiveInputStream in = new ArchiveStreamFactory()
					.createArchiveInputStream(ArchiveStreamFactory.ZIP,
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
			System.err.println(">>>Error: cannot find file");
		} catch (ArchiveException e) {
			System.err.println(">>>Error: Format not support, support zip format");
		} catch (IOException e) {
			System.err.println(">>>Error: IO exception in file generation");
		}
	}

	public static void zipFolder(String zipDir, String destFile) {
		File outFile = new File(destFile);
		try {
			outFile.createNewFile();
			BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(
					new FileOutputStream(outFile));
			ArchiveOutputStream out = new ArchiveStreamFactory().createArchiveOutputStream(ArchiveStreamFactory.JAR, bufferedOutputStream);
			if (zipDir.charAt(zipDir.length() - 1) != '/') {
				zipDir += '/';
			}
			Iterator<File> files = FileUtils.iterateFiles(new File(zipDir), null, true);
			while (files.hasNext()) {
				File file = files.next();
				String file_path = file.getPath().replace("\\", "/"); //for windows
				String entry_name = file_path.replace(zipDir, "");
				ZipArchiveEntry zipArchiveEntry = new ZipArchiveEntry(file, entry_name);
				out.putArchiveEntry(zipArchiveEntry);
				IOUtils.copy(new FileInputStream(file), out);
				out.closeArchiveEntry();
			}
			out.finish();
			out.close();
		} catch (IOException e) {
			System.err.println(">>>Error: Failed generate the file");
		} catch (ArchiveException e) {
			System.err.println(">>>Error: Archive format not support");
		}
	}
	
	public static void main(String[] args) {
		zipFolder("D:/project/lrf_prj/client_prj/zip_test", "D:/project/lrf_prj/client_prj/zip_java.zip");
		//unzipFolder("D:/project/lrf_prj/client_prj/zip_java.zip", "D:/project/lrf_prj/client_prj/unzip");
	}

    
    public static void mainC(String [] args){
    	String work_dir = System.getProperty("user.dir");
    	System.out.println(work_dir);
    	String init_content = "AAAA" + System.lineSeparator() + "BBBB" + System.lineSeparator();
    	System.out.println("write file:");
    	file_action.write_file("./lab.txt",init_content);
    	System.out.println("read after write:");
    	String read_content= file_action.read_file("lab.txt");
    	System.out.println(read_content);
    	System.out.println("append file:");
    	file_action.append_file("./lab.txt","CCCC");
    	System.out.println("read file after append:");
    	read_content= file_action.read_file("lab.txt");
    	System.out.println(read_content);
    	System.out.println( file_action.delete_file("lab.txt"));
    }
}
