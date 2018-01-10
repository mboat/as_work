package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.event.EventManager;
	import com.event.EventType;
	import com.type.CommonConst;
	
	import flash.utils.ByteArray;
	

	public class BinProduct extends BaseProduct
	{
		public function BinProduct()
		{
			type=CommonConst.BIN;
			super();
		}
		
		override public function exec(sheetInfo:Object,port:int=1):void{
			super.exec(sheetInfo,port);	
			
			content={};
			if(clientBool){
				content[CommonConst.EXPORT_CLIENT]=portExec(sheetInfo.clientNames,sheetInfo.clientIndexs,sheetInfo.types,sheetInfo.contents);
			}
			if(serverBool){
				content[CommonConst.EXPORT_SERVER]=portExec(sheetInfo.serverNames,sheetInfo.serverIndexs,sheetInfo.types,sheetInfo.contents);
			}
			
			complete();
			
			EventManager.instance().dispatcherWithEvent(EventType.GET_DATA);
		}
		
		private function portExec(names:Array,indexs:Array,types:Array,contents:Array):ByteArray{
			var bytes:ByteArray =new ByteArray();
			var i:int=0;
			var len:int=names.length;
			
			bytes.writeInt(len);
			for(var i:int=0;i<len;i++){
				bytes.writeUTF(names[i]);
			}
			return bytes;
		}
		
	}
}