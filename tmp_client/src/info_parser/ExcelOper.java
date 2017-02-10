package public_lib;

import java.io.*;
import java.math.BigDecimal;
import java.util.*;
import java.util.Map.Entry;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelOper {
	public static final int Excel2003 = 0;
	public static final int Excel2007 = 1;

    /**
     * Open an Excel workbook ready for conversion.
     *
     * @param file An instance of the File class that encapsulates a handle
     *        to a valid Excel workbook. Note that the workbook can be in
     *        either binary (.xls) or SpreadsheetML (.xlsx) format.
     * @throws java.io.FileNotFoundException Thrown if the file cannot be located.
     * @throws java.io.IOException Thrown if a problem occurs in the file system.
     * @throws org.apache.poi.openxml4j.exceptions.InvalidFormatException Thrown
     *         if invalid xml is found whilst parsing an input SpreadsheetML
     *         file.
     */
    private Workbook openWorkbook(File file) throws FileNotFoundException, IOException {
        FileInputStream fis = null;
        try {
            System.out.println(">>>Info : Opening workbook [" + file.getName() + "]");
            String [] file_name = file.getName().split("\\.");
            int ExcelFormat = 0;
            if (file_name[1].equalsIgnoreCase("xlsx")){
                ExcelFormat = Excel2007;
            } else {
            	ExcelFormat = Excel2003;
            }
            fis = new FileInputStream(file);
            Workbook workbook_obj = getWorkbook(ExcelFormat, fis);
            return workbook_obj;
        }
        finally {
            if(fis != null) {
                fis.close();
            }
        }
    }
	
    public static void closeWorkbook(Workbook workbook) {
        try {
			workbook.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
		
    public static Workbook getWorkbook(int edition, InputStream in) throws IOException {
        if (edition == 0) {
            return new HSSFWorkbook(in);
        } else if (edition == 1) {
            return new XSSFWorkbook(in);
        }
        return null;
    }
    
    /**
     * readrow from specific worksheet
     * 
     * @param workbook
     * @param startRow
     * @param startCol
     * @param indexSheet
     * @return
     */
    public List<List<String>> getExcelString(Workbook workbook, int startRow, int startCol, int indexSheet) {
        List<List<String>> stringTable = new ArrayList<List<String>>();
        // get sheet object
        Sheet sheet = workbook.getSheetAt(indexSheet);
        // get maximum row number
        int rowNum = sheet.getLastRowNum();
        //System.out.println("row number is:" +  rowNum);
        for (int i = startRow; i <= rowNum; i++) {
        	//System.out.println("Processing row:" +  i);
            List<String> oneRow = new ArrayList<String>();
            Row row = sheet.getRow(i);
            // get the maximum column number
            int colNum = -1;
            if (row != null){
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
                    switch (cell.getCellType()) {
                    case Cell.CELL_TYPE_NUMERIC:
                        // 表格中返回的数字类型是科学计数法因此不能直接转换成字符串格式
                        cellValue = new BigDecimal(cell.getNumericCellValue()).toPlainString();
                        break;
                    case Cell.CELL_TYPE_STRING:
                        cellValue = cell.getStringCellValue();
                        break;
                    case Cell.CELL_TYPE_FORMULA:
                        cellValue = new BigDecimal(cell.getNumericCellValue()).toPlainString();
                        break;
                    case Cell.CELL_TYPE_BLANK:
                        cellValue = "";
                        break;
                    case Cell.CELL_TYPE_BOOLEAN:
                        cellValue = Boolean.toString(cell.getBooleanCellValue());
                        break;
                    case Cell.CELL_TYPE_ERROR:
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
    
    /**
     * 根据给定的数据直接生成workbook
     * 
     * @param workbook
     * @param sheetName
     * @param data
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

    /**
     * 往指定的sheet表中插入数据，插入的方法是提供一组valueMap。int[]是2维数组代表需要插入的数据坐标，从0开始
     * 
     * @param workbook
     * @param sheetIndex
     * @param valueMap
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

    /**
     * 设置指定行的行高
     * 
     * @param workbook
     * @param rowHeight
     * @param sheetIndex
     * @param rowIndex
     * @return
     */
    public static Workbook setRowHeight(Workbook workbook, int rowHight, int sheetIndex, int rowIndex) {
        Sheet sheet = workbook.getSheetAt(sheetIndex);
        Row row = sheet.getRow(rowIndex);
        row.setHeight((short) rowHight);
        return workbook;
    }

    /**
     * 设置列宽
     * 
     * @param workbook
     * @param columnWidth
     * @param sheetIndex
     * @param columnIndex
     * @return
     */
    public static Workbook setColumnWidth(Workbook workbook, int columnWidth, int sheetIndex, int columnIndex) {
        Sheet sheet = workbook.getSheetAt(sheetIndex);
        sheet.setColumnWidth(columnIndex, columnWidth);
        return workbook;
    }

    /**
     * 删除指定行
     * 
     * @param workbook
     * @param sheetIndex
     * @param rowIndex
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

    /**
     * 在指定位置插入空白行
     * 
     * @param workbook
     * @param sheetIndex
     * @param rowIndex
     * @return
     */
    public static Workbook insertBlankRow(Workbook workbook, int sheetIndex, int rowIndex) {
        Sheet sheet = workbook.getSheetAt(sheetIndex);
        int lastRowNum = sheet.getLastRowNum();
        if (rowIndex >= 0 && rowIndex <= lastRowNum) {
            sheet.shiftRows(rowIndex, lastRowNum, 1);
            // 获得上一行的Row对象
            Row preRow = sheet.getRow(rowIndex - 1);
            short rowNum = preRow.getLastCellNum();
            Row curRow = sheet.createRow(rowIndex);
            // 新生成的Row创建与上一个行相同风格的Cell
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
     * 根据sheet(0)作为模板重建workbook
     * 
     * @param workbook
     * @param sheetNum
     * @param sheetNames
     * @return
     */
    public static Workbook rebuildWorkbook(Workbook workbook, int sheetNum, String... sheetNames) {
        if(sheetNames.length == sheetNum){
            for (int i = 0; i < sheetNum; i++) {
                workbook.cloneSheet(0);
                // 生成后面的工作表并指定表名
                workbook.setSheetName(i + 1, sheetNames[i]);
            }
            // 删除第一张工作表
            workbook.removeSheetAt(0);
            return workbook;
        }
        return null;
    }
    
    public Map<String, List<List <String>>> GetExcelData(String excel_file){
    	Map<String, List<List <String>>> ExcelData = new HashMap<String, List<List <String>>>();
    	ExcelOper excel_obj = new ExcelOper();
    	File xlsx_file = new File(excel_file);
    	Workbook workbook_obj = null;
    	try {
			workbook_obj = excel_obj.openWorkbook(xlsx_file);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			System.out.println(">>>Error: xlsx file not exists.");
			return null;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			System.out.println(">>>Error: xlsx file open error.");
			return null;
		}
    	int sheet_number = workbook_obj.getNumberOfSheets();
    	for (int i = 0; i < sheet_number; i++){
    		String sheet_name = workbook_obj.getSheetName(i);
    		List<List <String>> sheetdata = excel_obj.getExcelString(workbook_obj, 0, 0, i);
    		ExcelData.put(sheet_name, sheetdata);
    	}
    	try {
			workbook_obj.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			System.out.println(">>>Warning: xlsx file close error.");
		}
    	return ExcelData;
    }
    
	public static void main(String[] argv) throws Exception{
		ExcelOper excel_obj = new ExcelOper();
		File xlsx_file = new File("suite_info3.xlsx");
		Workbook workbook_obj = excel_obj.openWorkbook(xlsx_file);
		List<List <String>> sheetdata = excel_obj.getExcelString(workbook_obj, 0, 0, 1);
		for (int i = 0 ; i <sheetdata.size(); i++){
			List<String> rowdata = sheetdata.get(i);
			System.out.println(rowdata.toString());
			//System.out.println(System.lineSeparator());
		}
	}

	
}