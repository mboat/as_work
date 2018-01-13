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
		}
	}
}