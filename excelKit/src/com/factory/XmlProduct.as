package com.factory
{
	import com.type.CommonConst;

	public class XmlProduct extends BaseProduct
	{
		public function XmlProduct()
		{
			type=CommonConst.XML;
			super();
		}
		
		override public function exec(sheetInfo:Object,port:int=1):void{
			super.exec(sheetInfo,port);	
		}
	}
}