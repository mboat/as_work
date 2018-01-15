package com.factory.worker
{
	import com.amf3.EAmf3Type;
	import com.as3xls.xls.Sheet;
	import com.type.CommonConst;
	
	import flash.utils.ByteArray;
	

	public class BinWorker extends BaseWorker
	{
		public function BinWorker(sid:int)
		{
			super(sid);
			format=CommonConst.BIN;
		}
		
		override public function parseExcel(port:int,sheet:Sheet,names:Array,typeIndex:int,colIndexs:Array,rowIds:Array):void{
			super.parseExcel(port,sheet,names,typeIndex,colIndexs,rowIds);	
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
			bytes.writeInt(len);
			for(i=0;i<len;i++){
				rowIndex=rowIds[i];
				for(var k:int=0;k<colIndexs.length;k++){
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
			
			var bytesLen:int=bytes.length;
			
			//输出端
			bytes.writeByte(port);
			//头部信息
			//索引，描述
			var keys:Array=["index","descr"];
			var types:Array=["integer","string"];
			len=keys.length;
			bytes.writeInt(len);
			for (i = 0; i < len; i++) 
			{
				bytes.writeUTF(keys[i]);
			}
			
			len=names.length;
			bytes.writeInt(len);
			for (i = 0; i < len; i++) 
			{
				colIndex=colIndexs[i];
				//收集对于数据
				var values:Array=[colIndex,sheet.getCell(0,colIndex).value];
				for(var j:int=0;j<keys.length;j++){
					
					itemType=types[j];
					if(itemType&&itemType.length>0){
						etype=EAmf3Type.getEAmf3TypeByKey(itemType);
					}else{
						etype=EAmf3Type.getEAmf3TypeByKey("string");
					}
					etype.writeFunction.apply(null,[bytes,values[j]]);
				}
			}
			
			//表格数据长度
			bytes.writeInt(bytesLen);
			bytes.position=0;
			
			trace(bytesLen,bytes.length)
			
			var exportName:String=sheet.getCell(0,0).value;
			//保存 .bin
			saveBytesFile(getOutputNativePath(exportName),bytes,completeAndRecoverWorker);
		}
	}
}