package com.factory.worker
{
	import com.as3xls.xls.Sheet;
	import com.type.CommonConst;
	
	public class JsonWorker extends BaseWorker
	{
		public function JsonWorker(sid:int)
		{
			super(sid);
			format=CommonConst.JSON;
		}
		override public function parseExcel(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.parseExcel(port,sheet,names,typeIndex,colIndexs,rowIds);	
			
			//成员变量
			var i:int=0;
			var len:int=rowIds.length;
			var keyLen:int=names.length;
			var colIndex:int=0;
			var rowIndex:int=0;
			
			//模板
			var templete:Array=[];
			for (i = 0; i < keyLen; i++) 
			{
				var item:Object={};
				colIndex=colIndexs[i];
				
				item["index"]=colIndex;
				item["key"]=names[i];
				item["descr"]=(sheet.getCell(rowIndex,colIndex).value);
				item["type"]=sheet.getCell(typeIndex,colIndex).value;
				templete.push(item);
			}
			
			var list:Array=[];
			for (i = 0; i < len; i++) 
			{
				rowIndex=rowIds[i];
				
				var tempObject:Object={};
				for (var j:int = 0; j < keyLen; j++) 
				{
					colIndex=colIndexs[j];	
					tempObject[names[j]]=sheet.getCell(rowIndex,colIndex).value;
				}
				list.push(tempObject);
			}
			var jsonObj:Object={"models":list,"templete":templete,"port":port};
			
			var exportName:String=sheet.getCell(0,0).value;
			//保存 .json
			saveTxtFile(getOutputNativePath(exportName),JSON.stringify(jsonObj,null," "),completeAndRecoverWorker);
		}
		
		override public function parse(port:int,fileName:String,headNames:Array,indexs:Array,types:Array,models:Array,descrs:Array):void{
			super.parse(port,fileName,headNames,indexs,types,models,descrs);
			//成员变量
			var i:int=0;
			var len:int=0;
			var colIndex:int=0;
			var rowIndex:int=0;
			
			var keyLen:int=headNames.length;
			//模板
			var templete:Array=[];
			for (i = 0; i < keyLen; i++) 
			{
				var item:Object={};
				colIndex=indexs[i];
				
				item["index"]=colIndex;
				item["key"]=headNames[i];
				item["descr"]=descrs[i];
				item["type"]=types[i];
				templete.push(item);
			}
			
			var list:Array=[];
			
			len=models.length;
			for (i = 0; i < len; i++) 
			{
				var model:Array=models[i];
				var tempObject:Object={};
				for (var j:int = 0; j < model.length; j++) 
				{
					tempObject[headNames[j]]=model[j];
				}
				list.push(tempObject);
			}
			var jsonObj:Object={"models":list,"templete":templete,"port":port};
			
			//保存 .json
			saveTxtFile(getOutputNativePath(fileName),JSON.stringify(jsonObj,null," "),completeAndRecoverWorker);
		}
		
	}
}