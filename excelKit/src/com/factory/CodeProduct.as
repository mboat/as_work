package com.factory
{
	import com.amf3.CodeExportType;
	import com.amf3.EAmf3Type;
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.templete.ClassPartASTemplte;
	import com.type.CommonConst;
	public class CodeProduct extends BaseProduct
	{
		private var preList:Array=[];
		private var afterList:Array=[];
		public function CodeProduct(sid:int)
		{
			super(sid);
			format=CommonConst.CODE;
		}
		override public function exec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.exec(port,sheet,names,typeIndex,colIndexs,rowIds);
			
			
			//package包
			var classPath:String = GlobalData.instance().class_path;
			addCodes(ClassPartASTemplte.writePackage(classPath));
			
			//class的注释
			preList.push(ClassPartASTemplte.writeMultiNote('配置生成类：'+sheet.name,{'author':"工具",'time':new Date()},true));
			
			var className:String=sheet.name+"CfgVo";
			//class 部分
			addCodes(ClassPartASTemplte.writeClass(className));
			
			//成员变量
			var i:int=0;
			var len:int=names.length;
			
			var member:String;
			var itemType:String;
			var colIndex:int=0;
			for(i=0;i<len;i++){
				member=names[i];
				colIndex=colIndexs[i];
				
				itemType=sheet.getCell(typeIndex,colIndex).value;
				var etype:EAmf3Type=EAmf3Type.getEAmf3TypeByKey(itemType);
				preList.push(ClassPartASTemplte.writeMemberVariable(member,1,etype.codes[CodeExportType.AS3],false,etype.initData));
			}
			
			//构造函数
			addCodes(ClassPartASTemplte.writeFunction(className));
			
			//保存 .as
			saveTxtFile(getCodeNativePath(className),mergeCodeWords(),saveComplete);
		}
		
		private function saveComplete():void{
			complete();
			recover();
		}
		
		private function addCodes(codes:Array):void{
			preList.push(codes[0]);
			afterList.unshift(codes[1]);
		}
		
		private function mergeCodeWords():String{
			
			var codewords:String='';
			
			var merges:Array=preList.concat(afterList);
			for(var i:int=0;i<merges.length;i++){
				codewords+=merges[i];
			}
			return codewords;
		}
	}
}