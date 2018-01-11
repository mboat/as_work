package com.factory
{
	import com.amf3.EAmf3Type;
	import com.as3xls.xls.Sheet;
	import com.data.GlobalData;
	import com.event.EventManager;
	import com.event.EventType;
	import com.type.CommonConst;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	

	public class BinProduct extends BaseProduct
	{
		public function BinProduct(sid:int)
		{
			super(sid);
			format=CommonConst.BIN;
		}
		
		override public function exec(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.exec(port,sheet,names,typeIndex,colIndexs,rowIds);	
			var bytes:ByteArray =new ByteArray();
			var i:int=0;
			var len:int=names.length;
			
			bytes.writeInt(len);
			for(i=0;i<len;i++){
				bytes.writeUTF(names[i]);
			}
			
			var rowIndex:int=0;
			var colIndex:int=0;
			var item:String;
			var itemType:String;
			var etype:EAmf3Type;
			len=rowIds.length;
			for(i=0;i<len;i++){
				rowIndex=rowIds[i];
				for(var k:int=1;k<colIndexs.length;k++){
					colIndex=colIndexs[k];
					item=sheet.getCell(rowIndex,colIndex).value;
					itemType=sheet.getCell(typeIndex,colIndex).value;
					if(itemType&&itemType.length>0){
						etype=EAmf3Type.getEAmf3TypeByKey(itemType);
					}else{
						etype=EAmf3Type.getEAmf3TypeByKey("string");
					}
					etype.writeFunction.apply(null,[bytes,item]);
				}
			}
			var outFile:File=GlobalData.instance().filesDict[CommonConst.OUTPUT_DIR];
			var path:String=outFile.nativePath+"/server/"+sheet.name+".bin";
			FileUtil.saveBytesFile(path,bytes,saveComplete);
		}
		
		private function saveComplete():void{
			complete();
			recover();
		}
	}
}