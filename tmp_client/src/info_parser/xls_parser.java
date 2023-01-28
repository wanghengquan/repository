/*
 * File: xls_parser.java
 * Description: Software command line parser definition
 * Author: Jason.Wang
 * Date:2017/02/13
 * Modifier:
 * Date:
 * Description:
 */
package info_parser;

import java.io.*;
import java.util.*;
import java.math.BigDecimal;
import java.util.Map.Entry;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/*
 * PlatUML graph
 * @startuml
 * :Hello world;
 * :This is on defined on
 * several **lines**;
 * @enduml
 */
public class xls_parser {
	public static final int Excel2003 = 0;
	public static final int Excel2007 = 1;
	private static final Logger XLS_LOGGER = LogManager.getLogger(xls_parser.class.getName());

	/*
	 * Open an Excel workbook ready for conversion.
	 *
	 * @param file An instance of the File class that encapsulates a handle to a
	 * valid Excel workbook. Note that the workbook can be in either binary
	 * (.xls) or SpreadsheetML (.xlsx) format.
	 * 
	 * @throws java.io.FileNotFoundException Thrown if the file cannot be
	 * located.
	 * 
	 * @throws java.io.IOException Thrown if a problem occurs in the file
	 * system.
	 * 
	 * @throws org.apache.poi.openxml4j.exceptions.InvalidFormatException Thrown
	 * if invalid xml is found whilst parsing an input SpreadsheetML file.
	 */
	public xls_parser() {

	}

	private Workbook openWorkbook(
			File file
			) throws FileNotFoundException, IOException {
		FileInputStream fis = null;
		try {
			System.out.println(">>>Info: Opening workbook [" + file.getName() + "]");
			String[] file_name = file.getName().split("\\.");
			int ExcelFormat = 0;
			if (file_name[1].equalsIgnoreCase("xlsx")) {
				ExcelFormat = Excel2007;
			} else {
				ExcelFormat = Excel2003;
			}
			fis = new FileInputStream(file);
			Workbook workbook_obj = getWorkbook(ExcelFormat, fis);
			return workbook_obj;
		} finally {
			if (fis != null) {
				fis.close();
			}
		}
	}

	private void closeWorkbook(Workbook workbook) {
		try {
			workbook.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private Workbook getWorkbook(int edition, InputStream in) throws IOException {
		if (edition == 0) {
			return new HSSFWorkbook(in);
		} else if (edition == 1) {
			return new XSSFWorkbook(in);
		}
		return null;
	}

	/*
	 * readrow from specific worksheet
	 * 
	 * @param workbook
	 * 
	 * @param startRow
	 * 
	 * @param startCol
	 * 
	 * @param indexSheet
	 * 
	 * @return
	 */
	private List<List<String>> getExcelString(Workbook workbook, int startRow, int startCol, int indexSheet) {
		List<List<String>> stringTable = new ArrayList<List<String>>();
		// get sheet object
		Sheet sheet = workbook.getSheetAt(indexSheet);
		// get maximum row number
		int rowNum = sheet.getLastRowNum();
		// System.out.println("row number is:" + rowNum);
		for (int i = startRow; i <= rowNum; i++) {
			// System.out.println("Processing row:" + i);
			List<String> oneRow = new ArrayList<String>();
			Row row = sheet.getRow(i);
			// get the maximum column number
			int colNum = -1;
			if (row != null) {
				colNum = row.getLastCellNum();
			} else {
				oneRow.add(" ");
			}
			for (int j = startCol; j < colNum; j++) {
				// current cell
				Cell cell = row.getCell(j);
				String cellValue = null;
				if (cell != null) {
					// get the cell type for every cell
					switch (cell.getCellTypeEnum()) {
					case NUMERIC:
						cellValue = new BigDecimal(cell.getNumericCellValue()).toPlainString();
						break;
					case STRING:
						cellValue = cell.getStringCellValue();
						break;
					case FORMULA:
						cellValue = new BigDecimal(cell.getNumericCellValue()).toPlainString();
						break;
					case BLANK:
						cellValue = "";
						break;
					case BOOLEAN:
						cellValue = Boolean.toString(cell.getBooleanCellValue());
						break;
					case ERROR:
						cellValue = "ERROR";
						break;
					default:
						cellValue = "UNDEFINE";
					}
				} else {
					cellValue = "";
				}
				// generate one row in list
				oneRow.add(cellValue);
			}
			stringTable.add(oneRow);
		}
		return stringTable;
	}

	/*
	 * @param workbook
	 * 
	 * @param sheetName
	 * 
	 * @param data
	 * 
	 * @return
	 */
	public static Workbook createExcel(Workbook workbook, String sheetName, List<List<String>> data) {
		Sheet sheet = workbook.createSheet(sheetName);
		for (int i = 0; i < data.size(); i++) {
			List<String> oneRow = data.get(i);
			Row row = sheet.createRow(i);
			for (int j = 0; j < oneRow.size(); j++) {
				Cell cell = row.createCell(j);
				cell.setCellValue(oneRow.get(j));
			}
		}
		return workbook;
	}

	/*
	 * @param workbook
	 * 
	 * @param sheetIndex
	 * 
	 * @param valueMap
	 * 
	 * @return
	 */
	public static Workbook insertExcel(Workbook workbook, int sheetIndex, Map<int[], String> valueMap) {
		Sheet sheet = workbook.getSheetAt(sheetIndex);
		Iterator<Entry<int[], String>> it = valueMap.entrySet().iterator();
		while (it.hasNext()) {
			Entry<int[], String> cellEntry = it.next();
			int x = cellEntry.getKey()[0];
			int y = cellEntry.getKey()[1];
			String value = cellEntry.getValue();
			Row row = sheet.getRow(y);
			Cell cell = row.getCell(x);
			cell.setCellValue(value);
		}
		return workbook;
	}

	/*
	 * @param workbook
	 * 
	 * @param rowHeight
	 * 
	 * @param sheetIndex
	 * 
	 * @param rowIndex
	 * 
	 * @return
	 */
	public static Workbook setRowHeight(Workbook workbook, int rowHight, int sheetIndex, int rowIndex) {
		Sheet sheet = workbook.getSheetAt(sheetIndex);
		Row row = sheet.getRow(rowIndex);
		row.setHeight((short) rowHight);
		return workbook;
	}

	/*
	 * @param workbook
	 * 
	 * @param columnWidth
	 * 
	 * @param sheetIndex
	 * 
	 * @param columnIndex
	 * 
	 * @return
	 */
	public static Workbook setColumnWidth(Workbook workbook, int columnWidth, int sheetIndex, int columnIndex) {
		Sheet sheet = workbook.getSheetAt(sheetIndex);
		sheet.setColumnWidth(columnIndex, columnWidth);
		return workbook;
	}

	/*
	 * @param workbook
	 * 
	 * @param sheetIndex
	 * 
	 * @param rowIndex
	 * 
	 * @return
	 */
	public static Workbook removeRow(Workbook workbook, int sheetIndex, int rowIndex) {
		Sheet sheet = workbook.getSheetAt(sheetIndex);
		int lastRowNum = sheet.getLastRowNum();
		if (rowIndex >= 0 && rowIndex < lastRowNum) {
			sheet.shiftRows(rowIndex + 1, lastRowNum, -1);
		}
		if (rowIndex == lastRowNum) {
			sheet.removeRow(sheet.getRow(rowIndex));
		}
		return workbook;
	}

	/*
	 * @param workbook
	 * 
	 * @param sheetIndex
	 * 
	 * @param rowIndex
	 * 
	 * @return
	 */
	public static Workbook insertBlankRow(Workbook workbook, int sheetIndex, int rowIndex) {
		Sheet sheet = workbook.getSheetAt(sheetIndex);
		int lastRowNum = sheet.getLastRowNum();
		if (rowIndex >= 0 && rowIndex <= lastRowNum) {
			sheet.shiftRows(rowIndex, lastRowNum, 1);
			Row preRow = sheet.getRow(rowIndex - 1);
			short rowNum = preRow.getLastCellNum();
			Row curRow = sheet.createRow(rowIndex);
			for (short i = preRow.getFirstCellNum(); i < rowNum; i++) {
				Cell cell = preRow.getCell(i);
				CellStyle style = cell.getCellStyle();
				curRow.createCell(i).setCellStyle(style);
			}
			return workbook;
		}
		return null;
	}

	/**
	 * @param workbook
	 * @param sheetNum
	 * @param sheetNames
	 * @return
	 */
	public static Workbook rebuildWorkbook(Workbook workbook, int sheetNum, String... sheetNames) {
		if (sheetNames.length == sheetNum) {
			for (int i = 0; i < sheetNum; i++) {
				workbook.cloneSheet(0);
				workbook.setSheetName(i + 1, sheetNames[i]);
			}
			workbook.removeSheetAt(0);
			return workbook;
		}
		return null;
	}

	public Map<String, List<List<String>>> GetExcelData(String excel_file) {
		Map<String, List<List<String>>> ExcelData = new HashMap<String, List<List<String>>>();
		File xlsx_file = new File(excel_file);
		Workbook workbook_obj = null;
		try {
			workbook_obj = openWorkbook(xlsx_file);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			XLS_LOGGER.error("Error: xlsx file not exists.");
			return null;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
			XLS_LOGGER.error("Error: xlsx file open error.");
			return null;
		} catch (Exception e) {
			// e.printStackTrace();
			XLS_LOGGER.error("Error: Excel file open error. Please confirm your Excel file:");
			XLS_LOGGER.error("-> 1. Excel2007 format, file name end with .xlsx");
			XLS_LOGGER.error("-> 2. Excel2003 format, file name end with .xls");
			return null;
		}
		int sheet_number = workbook_obj.getNumberOfSheets();
		for (int i = 0; i < sheet_number; i++) {
			String sheet_name = workbook_obj.getSheetName(i);
			List<List<String>> sheetdata = getExcelString(workbook_obj, 0, 0, i);
			ExcelData.put(sheet_name, sheetdata);
		}
		closeWorkbook(workbook_obj);
		return ExcelData;
	}

	public static void main(String[] argv) throws Exception {
		xls_parser excel_obj = new xls_parser();
		File xlsx_file = new File("suite_info3.xlsx");
		Workbook workbook_obj = excel_obj.openWorkbook(xlsx_file);
		List<List<String>> sheetdata = excel_obj.getExcelString(workbook_obj, 0, 0, 1);
		for (int i = 0; i < sheetdata.size(); i++) {
			List<String> rowdata = sheetdata.get(i);
			System.out.println(rowdata.toString());
		}
	}
}