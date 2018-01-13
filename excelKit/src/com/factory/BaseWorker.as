package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.event.EventManager;
	import com.event.EventType;
	import com.type.CommonConst;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class BaseWorker
	{
		/**
		 *w唯一id 
		 */		
		private var _id:int=0;
		/**
		 *数据存储变量 
		 */		
		protected var content:*;
		/**
		 * 状态：-1.初始，0.进行重，1.完成 
		 */		
		protected var status:int=-1;
		/**
		 *输出类型 
		 */		
		public var format:int=0;
		private var _port:int=-1;
		/**
		 *输出路径记录 
		 */		
		private var _outPath:String;
		/**
		 *code输出路径记录 
		 */		
		private var _codePath:String;
		
		public function BaseWorker(sid:int)
		{
			_id=sid;
		}
		
		/**
		 *输出端 
		 */
		public function get port():int
		{
			return _port;
		}

		/**
		 * @private
		 */
		public function set port(value:int):void
		{
			_port = value;
		}

		/**
		 * 执行解析 
		 * @param port 输出方
		 * @param sheet 工作簿数据
		 * @param names 头部字段数组
		 * @param typeIndex  type类型所在的index
		 * @param colIndexs  属于字段的index组
		 * @param rowIds     条目item的index组
		 * 
		 */			
		public function excelExec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			status=0;
			_port=port;
		}
		
		public function xmlExec():void{
			
		}
		/**
		 * 保存二进制文件 
		 * @param fileName
		 * @param bytes
		 * @param saveComplete
		 * 
		 */		
		public function saveBytesFile(path:String,bytes:ByteArray,saveComplete:Function=null):void{
			FileUtil.saveBytesFile(path,bytes,saveCloseHandler);
			function saveCloseHandler():void{
				EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>保存完成，路径："+path);
				if(saveComplete!=null){
					saveComplete.apply();
				}
			}
		}
		
		/**
		 * 保存文本文件 
		 * @param fileName
		 * @param txt
		 * @param saveComplete
		 */		
		public function saveTxtFile(path:String,txt:String,saveComplete:Function=null):void{
			FileUtil.saveFile(path,txt,saveCloseHandler);
			function saveCloseHandler():void{
				EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>保存完成，路径："+path);
				if(saveComplete!=null){
					saveComplete.apply();
				}
			}
		}
		
		protected function completeAndRecoverWorker():void{
			complete();
			recover();
		}
		
		/**
		 * 获取保存文件路径 
		 * @param fileName
		 * @return 
		 * 
		 */		
		public function getOutputNativePath(fileName:String):String{
			return getOutputPath()+"/"+getPortFileName()+"/"+getFormatFileName()+"/"+fileName+getSuffix();
		}
		
		public function getFormatFileName():String{
			if(format==CommonConst.BIN){
				return "bin";
			}
			else if(format==CommonConst.XML){
				return "xml";
			}
			else if(format==CommonConst.JSON){
				return "json";
			}
			else if(format==CommonConst.CODE){
				return "as";
			}
			else if(format==CommonConst.EXCEL){
				return "xls";
			}
			return "";
		}
		
		/**
		 * 获取保存文件路径 
		 * @param fileName
		 * @return 
		 * 
		 */		
		public function getCodeNativePath(fileName:String):String{
			return getCodePath()+"/"+fileName+getSuffix();
		}
		
		/**
		 * 获取输出目录 路径
		 * @return 
		 */		
		protected function getOutputPath():String{
			if(_outPath==null){
				var outFile:File=GlobalData.instance().filesDict[CommonConst.OUTPUT_DIR];
				_outPath=outFile.nativePath;
			}
			return _outPath;
		}
		
		/**
		 * 获取code输出目录路径
		 * @return 
		 */		
		protected function getCodePath():String{
			if(_codePath==null){
				var file:File=GlobalData.instance().filesDict[CommonConst.CODE_DIR];
				_codePath=file.nativePath;
			}
			return _codePath;
		}
		
		/**
		 * 获取后缀
		 * @return 
		 * 
		 */		
		protected function getSuffix():String{
			return "."+getFormatFileName();
		}
		
		/**获取输出端文件夹名字*/		
		protected function getPortFileName():String{
			if(_port==CommonConst.EXPORT_CLIENT){
				return 'client';
			}else{
				return 'server';
			}
		}
		
		/**
		 *完成函数 
		 * 
		 */		
		protected function complete():void{
			status=1;
		}
		
		public function recover():void{
			EventManager.instance().dispatcherWithEvent(EventType.GET_RECOVER,this);
		}
		/**
		 * 唯一id 
		 * @return 
		 * 
		 */		
		public function getId():int{
			return _id;
		}
		/**
		 * 获取当前的数据集 
		 * @return 
		 * 
		 */		
		public function getProducts():*{
			
			return content;
		}
		/**
		 * 获取状态 
		 * @return 
		 * 
		 */		
		public function getStatus():int{
			return status;
		}
		/**
		 *重置数据 
		 * 
		 */		
		public function reset():void{
			content=null;
			status=-1;
			_port=0;
		}
	}
}