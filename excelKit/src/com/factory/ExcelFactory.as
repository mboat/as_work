package com.factory
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.event.EventManager;
	import com.event.EventType;
	import com.factory.worker.BaseWorker;
	import com.type.CommonConst;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;

	public class ExcelFactory extends BaseFactory
	{
		private static var _instance:ExcelFactory;
		
		private var clientNames:Array=[];
		private var clientIndexs:Array=[];
		private var itemsIndex:Array=[];
		private var typeIndex:int=-1;
		private var serverNames:Array=[];
		private var serverIndexs:Array=[];
		public function ExcelFactory()
		{
			super();
		}
		
		public static function instance():ExcelFactory{
			if(_instance==null){
				_instance=new ExcelFactory();
			}
			return _instance;
		}
		
		/**
		 * 解析表格数据源
		 * @param file
		 * 
		 */		
		override public function parseFile(file:File):void{
			super.parseFile(file);
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>正在处理文件："+file.nativePath);
			var excelFile:ExcelFile=new ExcelFile();
			
			excelFile.loadFromByteArray(FileUtil.getBytesByFile(file));
			
			var sheetLen:int=excelFile.sheets.length;
			for(var i:int=0;i<sheetLen;i++){
				paserSheet(excelFile.sheets[i]);
			}
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>完成处理文件："+file.nativePath);
			EventManager.instance().dispatcherWithEvent(EventType.FILE_PASER_COMPLETE);
		}
		/**
		 * 解析工作簿 
		 * @param sheet
		 * 
		 */				
		public function paserSheet(sheet:Sheet):void{
			var exportName:String=sheet.getCell(0,0).value;
			if(exportName==null||exportName.length==0){
				return;
			}
			var msg:String=sheet.name+"-"+exportName;
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>解析："+msg);
			
			var rows:int=sheet.rows;
			var cols:int=sheet.cols;
			
			var info:Object;
			var content:*;
			
			clientNames.length=0;
			clientIndexs.length=0;
			serverNames.length=0;
			serverIndexs.length=0;
			typeIndex=2;
			itemsIndex.length=0;
			
			var headEndIndex:int=4;
			for(var i:int=1;i<headEndIndex;i++){
				content=sheet.getCell(i,0).value;
				if(clientBool&&content==CommonConst.EXCEL_CLIENT){
					info=readRowToCols(sheet,i,cols);
					clientNames=info.contents;
					clientIndexs=info.indexs;
				}
				
				if(content==CommonConst.EXCEL_TYPE){
					typeIndex=i;
				}
				
				if(serverBool&&content==CommonConst.EXCEL_SERVER){
					info=readRowToCols(sheet,i,cols);
					serverNames=info.contents;
					serverIndexs=info.indexs;
				}
			}
			
			for(i=headEndIndex;i<rows;i++){
				content=sheet.getCell(i,0).value;
				if(content!=CommonConst.EXCEL_NO){
					itemsIndex.push(i);
				}
				if(content==CommonConst.EXCEL_END){
					break;
				}
			}
			
			if(clientBool){
				exportSheet(CommonConst.EXPORT_CLIENT,_data.client_formats,sheet,clientNames,clientIndexs,typeIndex,itemsIndex);
			}
			if(serverBool){
				exportSheet(CommonConst.EXPORT_SERVER,_data.server_formats,sheet,serverNames,serverIndexs,typeIndex,itemsIndex);
			}
			
		}
		
		private function readRowToCols(sheet:Sheet,index:int,cols:int):Object{
			var contents:Array=[];
			var indexs:Array=[];
			for(var k:int=1;k<cols;k++){
				var content:String=sheet.getCell(index,k).value;
				if(content&&content.length>0){
					contents.push(content);
					indexs.push(k);
				}
			}
			return {"contents":contents,"indexs":indexs};
		}
		
		private function exportSheet(port:int,formats:int,sheet:Sheet,names:Array=null,colIndexs:Array=null,typesIndex:int=-1,rowsIndex:Array=null):void{
			
			var len:int=_data.formatLen;
			var i:int=0,result:int;
			for(i=0;i<len;i++){
				result=formats>>(len-i-1)&1;
				if(result==1){
					FactoryManager.instance().exportFormatByExcel(port,i,sheet,names,colIndexs,typesIndex,rowsIndex);
				}
			}
		}
	}
}