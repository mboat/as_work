package com.factory
{
	import com.type.CommonConst;

	public class JsonProduct extends BaseProduct
	{
		public function JsonProduct()
		{
			type=CommonConst.JSON;
			super();
		}
		override public function exec(sheetInfo:Object,port:int=1):void{
			super.exec(sheetInfo,port);	
		}
	}
}