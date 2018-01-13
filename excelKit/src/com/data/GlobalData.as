package com.data
{
	import com.type.CommonConst;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	/**
	 * 数据存储类 
	 * @author nos
	 * 
	 */	
	public class GlobalData
	{
		/**
		 *传入参数 
		 */		
		public var arguments:Array;
		/**
		 *导出文件目录字典 
		 */		
		public var filesDict:Dictionary =new Dictionary(true);
		/**
		 *格式通道个数
		 */		
		public var formatLen:int=5;
		/**
		 *前端多个格式的导出值 
		 */		
		public var client_formats:int=0;
		/**
		 *后端多个格式的导出值 
		 */	
		public var server_formats:int=0;
		/**
		 * 数据源格式选择 
		 */		
		public var origin_format:int=0;
		/**
		 *生成代码的路径 
		 */		
		public var class_path:String;
		
		/**
		 * 输出格式选择数据
		 */		
		public var exportFormatDict:Dictionary =new Dictionary(true);
		/**
		 *源数据对应导出格式集 
		 */		
		private var orgToFormatDict:Dictionary=new Dictionary(true);
		/**
		 * 指定文件后缀
		 */		
		private var _extsDict:Dictionary =new Dictionary(true);
		private static var _instance:GlobalData;
		public function GlobalData()
		{
			orgToFormatDict[CommonConst.EXCEL]=[CommonConst.BIN,CommonConst.XML,CommonConst.JSON,CommonConst.CODE];
			orgToFormatDict[CommonConst.XML]=[CommonConst.BIN,CommonConst.JSON];
			orgToFormatDict[CommonConst.JSON]=[CommonConst.BIN,CommonConst.XML];
			
			_extsDict[CommonConst.EXCEL]=['xls','xlsx'];
			_extsDict[CommonConst.XML]=['xml'];
			_extsDict[CommonConst.JSON]=['json'];
		}
		/**
		 * 根据数据源类型获取后缀 
		 * @param format
		 * @return 
		 * 
		 */		
		public function getExtsByOrigin(format:int):Array{
			return _extsDict[format]
		}
		/**
		 * 根据数据源格式获取输出格式 
		 * @param format
		 * @return 
		 * 
		 */		
		public function getOriginFormats(format:int):Array{
			return orgToFormatDict[format];
		}
		
		/**
		 * 单列 
		 * @return 
		 * 
		 */		
		public static function instance():GlobalData
		{ 
			if(_instance==null) _instance =new GlobalData();
			
			return _instance;
		}
	}
}