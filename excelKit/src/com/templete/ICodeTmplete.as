package com.templete
{
	public interface ICodeTmplete
	{
		/**
		 * 写 包及路径 
		 * @param pPath
		 * @return 
		 * 
		 */		
		function writePackage(pPath:String):Array;
		/**
		 * 写 类的引用 部分 
		 * @param cla
		 * @return 
		 * 
		 */		
		function writeImportClass(cla:Class):String;
		/**
		 * 写 类的名字部分 
		 * @param claName
		 * @param exClassName
		 * @return 
		 * 
		 */		
		function writeClass(claName:String,exClassName:String=null):Array;
		
		/**
		 * 写 函数部分 
		 * @param funcName
		 * @param packsafe
		 * @param returnType
		 * @param params
		 * @param static
		 * @param override
		 * @return 
		 * 
		 */		
		function writeFunction(funcName:String,packsafe:int=1,returnType:String=null,
											 params:String=null,static:Boolean=false,override:Boolean=false):Array;
		
		/**
		 * 写 成员变量 
		 * @param varName
		 * @param packsafe
		 * @param type
		 * @param staticBool
		 * @param initData
		 * @return 
		 * 
		 */		
		function writeMemberVariable(varName:String,packsafe:int,type:String,staticBool:Boolean=false,initData:String=null):String;
		
		/**
		 * 写 单行注释 
		 * @param descr
		 * @return 
		 * 
		 */		
		function writeSingleNote(descr:String):String;
		/**
		 * 写 多行注释部分 
		 * @param descr
		 * @param args {xx:xxxx}
		 * @param classNote 是否是整个类的注释
		 * @return 
		 * 
		 */		
		function writeMultiNote(descr:String,args:Object=null,classNote:Boolean=false):String;
		/**
		 * 写绑定关键字部分 
		 * @return 
		 * 
		 */		
		function writeBindable():String;
		
		/**
		 * 写 镶嵌部分 
		 * @param urlPath
		 * @param mimeType
		 * @return 
		 * 
		 */		
		function writeEmbed(urlPath:String,mimeType:String):String;
	}
}