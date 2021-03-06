package com.type
{
	public class CommonConst
	{
		/**
		 *前端代码生成语言类型 
		 */		
		public static const CLIENT_CODE_TYPE:String = 'client_code';
		/**
		 *后端代码生成语言类型 
		 */		
		public static const SERVER_CODE_TYPE:String = 'server_code';
		/**
		 *生产代码的类包路径 
		 */		
		public static const CLASS_PATH:String='class_path';
		/**
		 * 数据源选择格式
		 */		
		public static const ORIGIN_FORMAT:String="origin_format";
		/**
		 *前端输出格式的关键字 
		 */		
		public static const CLIENT_FORMATS:String="client_formats";
		/**
		 *后端输出格式的关键字 
		 */		
		public static const SERVER_FORMATS:String="server_formats";
		/**
		 *配置目录的关键字 
		 */		
		public static const CFG_DIR:String="dir";
		/**
		 *配置目录 
		 */		
		public static const ORIGIN_DIR:String ="origin";
		/**
		 *输出目录 
		 */		
		public static const OUTPUT_DIR:String ="output";	
		/**
		 *代码输出目录 
		 */		
		public static const CODE_DIR:String="code";
		/**
		 * 输出bin
		 */
		public static const BIN:int=0;
		/**
		 * 输出XML
		 */
		public static const XML:int=1;
		/**
		 * 输出JSON
		 */
		public static const JSON:int=2;
		/**
		 * 输出code
		 */
		public static const CODE:int=3;
		/**
		 *输出excel 
		 */		
		public static const EXCEL:int=4;
		/**
		 *表格前端关键字 
		 */		
		public static const EXCEL_CLIENT:String="CLIENT";
		/**
		 *表格后端关键字 
		 */		
		public static const EXCEL_SERVER:String="SERVER";
		/**
		 *表格 过滤条目的关键字 
		 */		
		public static const EXCEL_NO:String="NO";
		/**
		 *表格 截止关键字 
		 */		
		public static const EXCEL_END:String="END";
		/**
		 *表格 字段类型关键字 
		 */		
		public static const EXCEL_TYPE:String="TYPE";
		/**
		 *导出 前端值
		 */		
		public static const EXPORT_CLIENT:int=1;
		/**
		 *导出后端值 
		 */		
		public static const EXPORT_SERVER:int=2;
	}
}