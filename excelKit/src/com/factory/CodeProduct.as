package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.type.CommonConst;

	public class CodeProduct extends BaseProduct
	{
		public function CodeProduct()
		{
			type=CommonConst.CODE;
			super();
		}
		override public function exec(sheetInfo:Object,port:int=1):void{
			super.exec(sheetInfo,port);	
		}
	}
}