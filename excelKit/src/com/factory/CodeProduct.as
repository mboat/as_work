package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.type.CommonConst;

	public class CodeProduct extends BaseProduct
	{
		public function CodeProduct()
		{
			format=CommonConst.CODE;
			super();
		}
		override public function exec(port:int,sheet:Sheet,names:Array=null,typeIndex:int=-1,colIndexs:Array=null,rowIds:Array=null):void{
			super.exec(port,sheet,names,typeIndex,colIndexs,rowIds);	
		}
	}
}