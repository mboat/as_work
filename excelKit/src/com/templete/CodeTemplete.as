package com.templete
{
	public class CodeTemplete implements ICodeTmplete
	{
		public function CodeTemplete()
		{
		}
		
		public function writePackage(pPath:String):Array
		{
			return null;
		}
		
		public function writeImportClass(cla:Class):String
		{
			return null;
		}
		
		public function writeClass(claName:String, exClassName:String=null):Array
		{
			return null;
		}
		
		public function writeFunction(funcName:String, packsafe:int=1, returnType:String=null, params:String=null, static:Boolean=false, override:Boolean=false):Array
		{
			return null;
		}
		
		public function writeMemberVariable(varName:String, packsafe:int, type:String, staticBool:Boolean=false, initData:String=null):String
		{
			return null;
		}
		
		public function writeSingleNote(descr:String):String
		{
			return null;
		}
		
		public function writeMultiNote(descr:String, args:Object=null, classNote:Boolean=false):String
		{
			return null;
		}
		
		public function writeBindable():String
		{
			return null;
		}
		
		public function writeEmbed(urlPath:String, mimeType:String):String
		{
			return null;
		}
	}
}