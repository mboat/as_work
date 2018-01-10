package com.factory
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.event.EventManager;
	import com.event.EventType;
	import com.type.CommonConst;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;

	public class FileFactory
	{
		private static var _instance:FileFactory;
		private var _data:GlobalData;
		public function FileFactory()
		{
			_data=GlobalData.instance();
		}
		/**
		 * 单列 
		 * @return 
		 * 
		 */		
		public static function instance():FileFactory{
			if(_instance==null) _instance =new FileFactory();
			return _instance;
		}
		
		/**
		 * 启动 
		 */		
		public function startup():void{
			var tempDir:File =_data.filesDict[CommonConst.EXCEL_DIR];
			var fileList:Array=FileUtil.readFilesByExts(tempDir,_data.fileExts,null,10);
			EventManager.instance().dispatcherWithEvent(EventType.ADD_LIST,fileList);
		}
		
		
		public function paserExcel(file:File):void{
			var excelFile:ExcelFile=new ExcelFile();
			excelFile.loadFromByteArray(FileUtil.getBytesByFile(file));
			
			var sheetLen:int=excelFile.sheets.length;
			for(var i:int=0;i<sheetLen;i++){
				var sheet:Sheet=excelFile.sheets[i];
			}
		}
		
		private function paserSheet(sheet:Sheet):void{
			
		}
	}
}