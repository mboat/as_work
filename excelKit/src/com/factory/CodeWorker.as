package com.factory
{
	import com.amf3.CodeType;
	import com.amf3.EAmf3Type;
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.templete.AsTemplete;
	import com.templete.ClassPartASTemplte;
	import com.templete.CodeTemplete;
	import com.templete.TsTemplete;
	import com.type.CommonConst;

	public class CodeWorker extends BaseWorker
	{
		private var preList:Array=[];
		private var afterList:Array=[];
		public function CodeWorker(sid:int)
		{
			super(sid);
			format=CommonConst.CODE;
		}
		override public function excelExec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.excelExec(port,sheet,names,typeIndex,colIndexs,rowIds);
			
			var gdata:GlobalData=GlobalData.instance();
			var codewriter:CodeTemplete;
			
			if(port==CommonConst.EXPORT_CLIENT){
				codeType=gdata.client_code;
			}else{
				codeType=gdata.server_code;
			}
			
			if(codeType==CodeType.AS3){
				codewriter=new AsTemplete();
			}
			else if(codeType==CodeType.TS){
				codewriter=new TsTemplete();
			}
			
			if(codewriter==null){
				completeAndRecoverWorker();
				return ;
			}
			//package包
			var classPath:String = gdata.class_path;
			addCodes(codewriter.writePackage(classPath));
			
			var className:String=sheet.name+"CfgVo";
			//class的注释
			preList.push(codewriter.writeMultiNote('配置生成类：'+className,{'author':"工具",'time':new Date()},true));
			
			//class 部分
			addCodes(codewriter.writeClass(className));
			
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
				
				preList.push(codewriter.writeMultiNote(sheet.getCell(0,colIndex).value));
				if(port==CommonConst.EXPORT_CLIENT){
					preList.push(codewriter.writeMemberVariable(member,1,etype.codes[codeType],false,etype.initData));
				}else{
					preList.push(codewriter.writeMemberVariable(member,1,etype.codes[codeType],false,etype.initData));
				}
			}
			
			//构造函数
			addCodes(codewriter.writeFunction(className));
			
			//保存 .as
			saveTxtFile(getCodeNativePath(className),mergeCodeWords(),completeAndRecoverWorker);
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