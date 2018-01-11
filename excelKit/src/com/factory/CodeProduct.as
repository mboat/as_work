package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.type.CommonConst;

	public class CodeProduct extends BaseProduct
	{
		public function CodeProduct(sid:int)
		{
			super(sid);
			format=CommonConst.CODE;
		}
		override public function exec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.exec(port,sheet,names,typeIndex,colIndexs,rowIds);	
		}
	}
}