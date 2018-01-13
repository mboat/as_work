package com.factory
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
		
		override public function excelExec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.excelExec(port,sheet,names,typeIndex,colIndexs,rowIds);	
		}
	}
}