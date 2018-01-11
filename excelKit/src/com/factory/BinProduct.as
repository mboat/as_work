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
			format=CommonConst.BIN;
			super();
		}
		
		override public function exec(port:int,sheet:Sheet,names:Array=null,typeIndex:int=-1,colIndexs:Array=null,rowIds:Array=null):void{
			super.exec(port,sheet,names,typeIndex,colIndexs,rowIds);	
			var bytes:ByteArray =new ByteArray();
			var i:int=0;
			var len:int=names.length;
			
			bytes.writeInt(len);
			for(i=0;i<len;i++){
				bytes.writeUTF(names[i]);
			}
			
			for(i=0;i<len;i++){
				
			}
			complete();
			
			EventManager.instance().dispatcherWithEvent(EventType.GET_DATA);
		}	
	}
}