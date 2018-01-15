package com.factory.worker
{
	import com.as3xls.xls.Sheet;
	import com.type.CommonConst;

	public class XmlWorker extends BaseWorker
	{
		public function XmlWorker(sid:int)
		{
			super(sid);
			format=CommonConst.XML;
		}
		
		override public function parseExcel(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.parseExcel(port,sheet,names,typeIndex,colIndexs,rowIds);	
			
			var headpart:String="<?xml version = '1.0' encoding = 'UTF-8'?>\n";
			var xml:XML=new XML("<models/>");
			//成员变量
			var i:int=0;
			var len:int=rowIds.length;
			var keyLen:int=names.length;
			var colIndex:int=0;
			var rowIndex:int=0;
			
			//模板
			var tmpXml:XMLList =new XMLList("<templete/>");
			for (i = 0; i < keyLen; i++) 
			{
				colIndex=colIndexs[i];
				var mdXml:XMLList=new XMLList("<col/>");
				mdXml.@index=colIndex;
				mdXml.@key=names[i];
				mdXml.@descr=sheet.getCell(rowIndex,colIndex).value;
				mdXml.@type=sheet.getCell(typeIndex,colIndex).value;
				tmpXml.appendChild(mdXml);
			}
			//成员变量
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
			var xmlWords:String=headpart+xml.toXMLString();
			var appendWords:String="<!--"+tmpXml.toXMLString()+"-->\n"+"<!--<port>"+port+"</port>-->";
			xmlWords=xmlWords.replace("<models>","<models>\n"+appendWords);
			//保存 .xml
			
			var exportName:String=sheet.getCell(0,0).value;
			saveTxtFile(getOutputNativePath(exportName),xmlWords,completeAndRecoverWorker);
		}
		
		override public function parse(port:int,fileName:String,headNames:Array,indexs:Array,types:Array,models:Array,descrs:Array):void{
			super.parse(port,fileName,headNames,indexs,types,models,descrs);
			//xml 头部
			var xmlHead:String="<?xml version = '1.0' encoding = 'UTF-8'?>\n";
			
			var i:int=0;
			var len:int=0;
			
			//模板
			len=headNames.length;
			var tmpXml:XMLList =new XMLList("<templete/>");
			for (i = 0; i < len; i++) 
			{
				var mdXml:XMLList=new XMLList("<col/>");
				mdXml.@index=indexs[i];
				mdXml.@key=headNames[i];
				mdXml.@descr=descrs[i];
				mdXml.@type=types[i];
				tmpXml.appendChild(mdXml);
			}
			
			var xml:XML=new XML("<models/>");
			//成员变量
			len=models.length;
			for (i = 0; i < len; i++) 
			{
				var model:Array=models[i];
				var subxml:XMLList =new XMLList("<model/>");
				for (var j:int = 0; j < model.length; j++) 
				{
					var keyXml:XMLList=new XMLList("<"+headNames[j]+"/>")
					keyXml.appendChild(model[j]);
					subxml.appendChild(keyXml);
				}
				
				xml.appendChild(subxml);
			}
			var xmlWords:String=xmlHead+xml.toXMLString();
			var appendWords:String="<!--"+tmpXml.toXMLString()+"-->\n"+"<!--<port>"+port+"</port>-->";
			xmlWords=xmlWords.replace("<models>","<models>\n"+appendWords);
			//保存 .xml
			saveTxtFile(getOutputNativePath(fileName),xmlWords,completeAndRecoverWorker);
		}
	}
}