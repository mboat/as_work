package com.templete
{
	import avmplus.getQualifiedClassName;

	public class AsTemplete extends CodeTemplete
	{
		public function AsTemplete()
		{
			super();
		}
		
		/**
		 * 写 包及路径 
		 * @param pPath
		 * @return 
		 * 
		 */		
		override public function writePackage(pPath:String):Array{
			var content:String="package";
			if(pPath&&pPath.length>0){
				content +=" ";
				content +=pPath;
			}
			
			content +="\n{\n";
			
			return [content,"\n}\n"];
		}
		/**
		 * 写 类的引用 部分 
		 * @param cla
		 * @return 
		 * 
		 */		
		override public function writeImportClass(cla:Class):String{
			return "	import "+getQualifiedClassName(cla).split("::").join(".")+";\n";
		}
		/**
		 * 写 类的名字部分 
		 * @param claName
		 * @param exClassName
		 * @return 
		 * 
		 */		
		override public function writeClass(claName:String,exClassName:String=null):Array{
			var tabs:String="	";
			var content:String=tabs+"public class "+claName;
			if(exClassName&&exClassName.length>0){
				var lastIndex:int=exClassName.lastIndexOf('.');
				if(lastIndex>=0){
					exClassName=exClassName.substring(lastIndex+1);
				}
				content+=" extends "+exClassName;
				
			}
			content +="\n"+tabs+"{\n";
			return [content,"\n"+tabs+"}\n"];
		}
		
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
		override public function writeFunction(funcName:String,packsafe:int=1,returnType:String=null,
											 params:String=null,static:Boolean=false,override:Boolean=false):Array
		{
			var tabs:String ="		";
			var content:String=tabs;
			if(packsafe==1){
				content+="public ";
			}
			else if(packsafe==2){
				content+="protected ";
			}
			else {
				content+="private ";
			}
			if(static){
				content+="";
			}else if(override){
				content+="override ";
			}
			content +="function "+funcName;
			if(params&&params.length>0){
				content+="("+params+")";
			}else{
				content +="()";
			}
			
			if(returnType&&returnType.length){
				content +=":"+returnType;
			}
			content +="\n"+tabs+"{\n";
			return [content,"\n"+tabs+"}\n"];
		}
		
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
		override public function writeMemberVariable(varName:String,packsafe:int,type:String,staticBool:Boolean=false,initData:String=null):String
		{
			var tabs:String="		";
			var content:String=tabs;
			if(packsafe==1){
				content+="public ";
			}
			else if(packsafe==2){
				content+="protected ";
			}
			else {
				content+="private ";
			}
			
			if(staticBool){
				content+="";
			}
			
			
			content +="var "+varName +" :"+type;
			if(initData&&initData.length>0){
				content +=" ="+initData;
			}
			return content +";\n";
		}
		
		/**
		 * 写 单行注释 
		 * @param descr
		 * @return 
		 * 
		 */		
		override public function writeSingleNote(descr:String):String
		{
			var tabs:String="		";
			return tabs+"//"+descr+"\n";
		}
		/**
		 * 写 多行注释部分 
		 * @param descr
		 * @param args {xx:xxxx}
		 * @param classNote 是否是整个类的注释
		 * @return 
		 * 
		 */		
		override public function writeMultiNote(descr:String,args:Object=null,classNote:Boolean=false):String{
			var tabs:String="		";
			if(classNote){
				tabs="	";
			}
			var content:String=tabs + "/**\n";
			content +=tabs +"*"+descr+"\n";
			if(args){
				for(var key:String in args){
					content +=tabs+"*@ "+key +" "+args[key]+"\n";
				}
			}
			content +=tabs + "*/\n";
			
			return content;
		}
		/**
		 * 写绑定关键字部分 
		 * @return 
		 * 
		 */		
		override public function writeBindable():String
		{
			var tabs:String ="		";
			return tabs+"[Bindable]\n";
		}
		
		/**
		 * 写 镶嵌部分 
		 * @param urlPath
		 * @param mimeType
		 * @return 
		 * 
		 */		
		override public function writeEmbed(urlPath:String,mimeType:String):String{
			var tabs:String ="		";
			var content:String=tabs;
			content +="[Embed(source ='"+urlPath+"', mimeType ='"+mimeType+"')]\n";
			return content;
		}
	}
}