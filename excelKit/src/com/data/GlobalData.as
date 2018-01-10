package com.data
{
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
		public var formatLen:int=4;
		/**
		 *多个格式的导出值 
		 */		
		public var format:int=0;
		/**
		 *导出通道个数 
		 */		
		public var exportLen:int=2;
		/**
		 * 多个端导出值
		 */		
		public var export:int=0;
		
		/**
		 *生成代码的路径 
		 */		
		public var class_path:String;
		/**
		 * 指定文件后缀
		 */		
		public var fileExts:Array=["xlsx","xls"];
		/**
		 * 输出格式选择数据
		 */		
		public var exportFormatDict:Dictionary =new Dictionary(true);
		private static var _instance:GlobalData;
		public function GlobalData()
		{
			
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