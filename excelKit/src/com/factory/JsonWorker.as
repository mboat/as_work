package com.factory
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
		override public function excelExec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.excelExec(port,sheet,names,typeIndex,colIndexs,rowIds);	
			
			//成员变量
			var i:int=0;
			var len:int=rowIds.length;
			var keyLen:int=names.length;
			var colIndex:int=0;
			var rowIndex:int=0;
			
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
			//保存 .json
			saveTxtFile(getOutputNativePath(sheet.name),JSON.stringify(list,null," "),completeAndRecoverWorker);
		}
		
	}
}