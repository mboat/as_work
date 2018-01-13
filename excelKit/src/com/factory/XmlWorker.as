package com.factory
{
	import com.amf3.CodeExportType;
	import com.amf3.EAmf3Type;
	import com.as3xls.xls.Sheet;
	import com.templete.ClassPartASTemplte;
	import com.type.CommonConst;

	public class XmlWorker extends BaseWorker
	{
		public function XmlWorker(sid:int)
		{
			super(sid);
			format=CommonConst.XML;
		}
		
		override public function excelExec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.excelExec(port,sheet,names,typeIndex,colIndexs,rowIds);	
			
			var headpart:String="<?xml version = '1.0' encoding = 'UTF-8'?>\n";
			var xml:XML=new XML("<list/>");
			//成员变量
			var i:int=0;
			var len:int=rowIds.length;
			var keyLen:int=names.length;
			var colIndex:int=0;
			var rowIndex:int=0;
			for (i = 0; i < len; i++) 
			{
				rowIndex=rowIds[i];
				
				var subxml:XMLList =new XMLList("<model/>");
				for (var j:int = 0; j < keyLen; j++) 
				{
					var keyXml:XMLList=new XMLList("<"+names[j]+"/>")
					colIndex=colIndexs[j];	
					keyXml.appendChild(sheet.getCell(rowIndex,colIndex).value);
					subxml.appendChild(keyXml);
				}
				
				xml.appendChild(subxml);
			}
			
			//保存 .xml
			saveTxtFile(getOutputNativePath(sheet.name),headpart+xml.toXMLString(),completeAndRecoverWorker);
		}
		
	}
}