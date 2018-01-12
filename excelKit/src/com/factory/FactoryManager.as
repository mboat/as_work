package com.factory
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.event.DataEvent;
	import com.event.EventManager;
	import com.event.EventType;
	import com.type.CommonConst;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	public class FactoryManager
	{
		private static var _instance:FactoryManager;
		private var _data:GlobalData;
		
		private var poolDict:Dictionary =new Dictionary(true);
		private var dataDict:Dictionary =new Dictionary(true);
		
		
		private var serverBool:Boolean;
		private var clientBool:Boolean;
		
		
		private var clientNames:Array=[];
		private var clientIndexs:Array=[];
		private var itemsIndex:Array=[];
		private var typeIndex:int=-1;
		private var serverNames:Array=[];
		private var serverIndexs:Array=[];
		
		
		private var _runningList:Array=[];
		private var sn:int=0;
		public function FactoryManager()
		{
			_data=GlobalData.instance();
			EventManager.instance().register(EventType.GET_DATA,getDataHandler);
			EventManager.instance().register(EventType.GET_RECOVER,getRecoverHandler);
		}
		
		/**
		 * 单列 
		 * @return 
		 * 
		 */		
		public static function instance():FactoryManager{
			if(_instance==null) _instance =new FactoryManager();
			return _instance;
		}
		
		
		private function getDataHandler(evt:DataEvent):void{
			var endProduct:BaseProduct=evt.data;
			var dataList:Array=dataDict[endProduct.format];
			if(dataList==null){
				dataList=dataDict[endProduct.format]=[];
			}
			
			var runIndex:int=_runningList.indexOf(endProduct.getId());
			if(runIndex>=0){
				_runningList.splice(runIndex,1);
			}
			dataList.push(endProduct.getProducts());
			
			endProduct.recover();
		}
		
		private function getRecoverHandler(evt:DataEvent):void{
			var endProduct:BaseProduct=evt.data;
			endProduct.reset();
			
			var productslist:Array=poolDict[endProduct.format];
			productslist.push(endProduct);
		}
		
		/**
		 * 启动 
		 */		
		public function startup():void{
			
			serverBool=_data.server_formats>0;
			clientBool=_data.client_formats>0;
			
			var tempDir:File =_data.filesDict[CommonConst.EXCEL_DIR];
			var fileList:Array=FileUtil.readFilesByExts(tempDir,_data.fileExts,null,10);
			EventManager.instance().dispatcherWithEvent(EventType.ADD_LIST,fileList);
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>读取表格文件完成");
		}
		
		
		public function paserExcel(file:File):void{
			
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
			var msg:String=sheet.name+"-"+sheet.getCell(0,0).value;
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>解析："+msg);
			var exportName:String=sheet.getCell(0,0).value;
			if(exportName==null||exportName.length==0){
				return;
			}
			
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
				if(content!=CommonConst.EXCEL_END){
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
					exportProduct(port,i,sheet,names,colIndexs,typesIndex,rowsIndex);
				}
			}
		}
		
		
		private function exportProduct(port:int,format:int,sheet:Sheet,names:Array=null,colIndexs:Array=null,typesIndex:int=-1,rowsIndex:Array=null):void{
			var list:Array=poolDict[format];
			if(list==null){
				list=poolDict[format]=[];
			}
			
			var startProduct:BaseProduct=null;
			if(list.length>0){
				startProduct=list.shift();
			}else{
				startProduct=createProduct(format);
			}
			
			if(startProduct){
				_runningList.push(startProduct.getId());
				startProduct.reset();
				startProduct.exec(port,sheet,names,typesIndex,colIndexs,rowsIndex);
			}else{
				EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>无法解析类型："+format);
			}
			
		}
		
		
		private function createProduct(type:int):BaseProduct{
			switch(type){
				case CommonConst.BIN:
					return new BinProduct(sn++);
				case CommonConst.XML:
					return new XmlProduct(sn++);
				case CommonConst.JSON:
					return new JsonProduct(sn++);
				case CommonConst.CODE:
					return new CodeProduct(sn++);
			}
			return null;
		}
	}
}