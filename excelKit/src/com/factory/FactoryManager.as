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
		private var types:Array=[];
		private var sheetContents:Array=[];
		
		private var serverNames:Array=[];
		private var serverIndexs:Array=[];
		
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
			var dataList:Array=dataDict[endProduct.type];
			if(dataList==null){
				dataList=dataDict[endProduct.type]=[];
			}
			
			dataList.push(endProduct.getProducts());
			
			endProduct.recover();
		}
		
		private function getRecoverHandler(evt:DataEvent):void{
			var endProduct:BaseProduct=evt.data;
			endProduct.reset();
			
			var productslist:Array=poolDict[endProduct.type];
			productslist.push(endProduct);
		}
		
		/**
		 * 启动 
		 */		
		public function startup():void{
			
			serverBool=_data.export&CommonConst.EXPORT_SERVER;
			clientBool=_data.export&CommonConst.EXPORT_CLIENT;
			
			var tempDir:File =_data.filesDict[CommonConst.EXCEL_DIR];
			var fileList:Array=FileUtil.readFilesByExts(tempDir,_data.fileExts,null,10);
			EventManager.instance().dispatcherWithEvent(EventType.ADD_LIST,fileList);
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>读取表格文件完成");
		}
		
		
		public function paserExcel(file:File):void{
			var excelFile:ExcelFile=new ExcelFile();
			excelFile.loadFromByteArray(FileUtil.getBytesByFile(file));
			
			var sheetLen:int=excelFile.sheets.length;
			for(var i:int=0;i<sheetLen;i++){
				paserSheet(excelFile.sheets[i]);
			}
			
			EventManager.instance().dispatcherWithEvent(EventType.FILE_PASER_COMPLETE);
		}
		
		private function exportSheet():void{
			var format:int=_data.format;
			var len:int=_data.formatLen;
			var i:int=0,result:int;
			for(i=0;i<len;i++){
				result=format>>(len-i-1)&1;
				if(result==1){
					exportProduct(i);
				}
			}
		}
		
		public function paserSheet(sheet:Sheet):void{
			var msg:String=sheet.name+"_"+sheet.getCell(0,0).value;
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>解析："+msg);
			trace("**********************"+msg+"******************************************");
			
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
			types.length=0;
			sheetContents.length=0;
			
			for(var i:int=0;i<3;i++){
				content=sheet.getCell(i,0).value;
				if(clientBool&&content==CommonConst.EXCEL_CLIENT){
					info=readRowToCols(i,cols);
					clientNames=info.contents;
					clientIndexs=info.indexs;
				}
				
				if(content==CommonConst.EXCEL_TYPE){
					info=readRowToCols(i,cols);
					types=info.contents;
				}
				if(serverBool&&content==CommonConst.EXCEL_SERVER){
					info=readRowToCols(i,cols);
					serverNames=info.contents;
					serverIndexs=info.indexs;
				}
			}
			
			for(i=3;i<rows;i++){
				content=sheet.getCell(i,0).value;
				if(content!=CommonConst.EXCEL_NO){
					info=readRowToCols(i,cols);
					sheetContents.push(info);
				}
				if(content!=CommonConst.EXCEL_END){
					break;
				}
			}
			
			exportSheet();
			
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
		
		private function exportProduct(type:int):void{
			var list:Array=poolDict[type];
			if(list==null){
				list=poolDict[type]=[];
			}
			var startProduct:BaseProduct=null;
			if(list.length>0){
				startProduct=list.shift();
			}else{
				startProduct=createProduct(type);
			}
			startProduct.reset();
			
			var info:Object={};
			info.clientNames=clientNames;
			info.clientIndexs=clientIndexs;
			
			info.serverNames=serverNames;
			info.clientIndexs=serverIndexs;
			
			info.types =types;
			info.contents =sheetContents;
			
			startProduct.exec(info,_data.export);
		}
		
		private function createProduct(type:int):BaseProduct{
			switch(type){
				case CommonConst.BIN:
					return new BinProduct();
				case CommonConst.XML:
					return new XmlProduct();
				case CommonConst.JSON:
					return new JsonProduct();
				case CommonConst.CODE:
					return new CodeProduct();
			}
			return new BaseProduct();
		}
	}
}