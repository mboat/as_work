package com.factory
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.event.DataEvent;
	import com.event.EventManager;
	import com.event.EventType;
	import com.factory.worker.BaseWorker;
	import com.factory.worker.BinWorker;
	import com.factory.worker.CodeWorker;
	import com.factory.worker.JsonWorker;
	import com.factory.worker.XmlWorker;
	import com.type.CommonConst;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class FactoryManager
	{
		private static var _instance:FactoryManager;
		private var _data:GlobalData;
		
		private var poolDict:Dictionary =new Dictionary(true);
		private var dataDict:Dictionary =new Dictionary(true);
		
		
		private var serverBool:Boolean;
		private var clientBool:Boolean;
		
		
		
		
		
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
		
		/**
		 * 收集数据处理函数 
		 * @param evt
		 * 
		 */		
		private function getDataHandler(evt:DataEvent):void{
			var endProduct:BaseWorker=evt.data;
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
		/**
		 * 回收产品利用函数 
		 * @param evt
		 * 
		 */		
		private function getRecoverHandler(evt:DataEvent):void{
			var endProduct:BaseWorker=evt.data;
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
			
			var tempDir:File =_data.filesDict[CommonConst.ORIGIN_DIR];
			var fileList:Array=[];
			FileUtil.readFilesByExts(tempDir,fileList,_data.getExtsByOrigin(_data.origin_format),null,10);
			EventManager.instance().dispatcherWithEvent(EventType.ADD_LIST,fileList);
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>读取表格文件完成");
		}
		
		public function getFormatWorker(format:int):BaseWorker{
			var list:Array=poolDict[format];
			if(list==null){
				list=poolDict[format]=[];
			}
			
			var startProduct:BaseWorker=null;
			if(list.length>0){
				startProduct=list.shift();
			}else{
				startProduct=createProduct(format);
			}
			return startProduct;
		}
		
		private function createProduct(type:int):BaseWorker{
			switch(type){
				case CommonConst.BIN:
					return new BinWorker(sn++);
				case CommonConst.XML:
					return new XmlWorker(sn++);
				case CommonConst.JSON:
					return new JsonWorker(sn++);
				case CommonConst.CODE:
					return new CodeWorker(sn++);
			}
			return null;
		}
		
		
		public function paserFile(file:File):void{
			
			var dataFactory:BaseFactory=null;
			if(_data.origin_format==CommonConst.EXCEL){
				dataFactory=ExcelFactory.instance();
			}
			else if(_data.origin_format==CommonConst.BIN){
				dataFactory=BinFactory.instance();
			}
			
			if(dataFactory){
				dataFactory.parseFile(file);
			}
			else{
				EventManager.instance().dispatcherWithEvent(">>>>>>暂时开放该类数据源解析，格式类型："+_data.origin_format+"\n");
			}
		}
		
		public function exportFormatByExcel(port:int,format:int,sheet:Sheet,names:Array=null,colIndexs:Array=null,typesIndex:int=-1,rowsIndex:Array=null):void{
			
			var startProduct:BaseWorker=getFormatWorker(format);
			if(startProduct){
				_runningList.push(startProduct.getId());
				startProduct.reset();
				startProduct.parseExcel(port,sheet,names,typesIndex,colIndexs,rowsIndex);
			}else{
				EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>无法解析类型："+format);
			}
		}
		
		public function exportFormat(port:int,fileName:String,headNames:Array,indexs:Array,types:Array,models:Array,descrs:Array):void{
			var len:int=_data.formatLen;
			var i:int=0,result:int;
			var formats:int=0;
			if(port==CommonConst.EXPORT_CLIENT){
				formats=_data.client_formats;
			}else{
				formats=_data.server_formats;
			}
			for(i=0;i<len;i++){
				result=formats>>(len-i-1)&1;
				if(result==1){
					var startProduct:BaseWorker=getFormatWorker(i);
					if(startProduct){
						_runningList.push(startProduct.getId());
						startProduct.reset();
						startProduct.parse(port,fileName,headNames,indexs,types,models,descrs);
					}else{
						EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>无法解析类型："+i);
					}
				}
			}
			
		}
	}
}