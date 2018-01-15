package com.factory
{
	import com.amf3.EAmf3Type;
	import com.event.EventManager;
	import com.event.EventType;
	import com.utils.FileUtil;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class BinFactory extends BaseFactory
	{
		private static var _instance:BinFactory;
		public function BinFactory()
		{
		}
		
		public static function instance():BinFactory{
			if(_instance==null){
				_instance=new BinFactory();
			}
			return _instance;
		}
		
		override public function parseFile(file:File):void{
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>正在处理文件："+file.nativePath);
			var bytes:ByteArray=FileUtil.getBytesByFile(file);
			
			
			bytes.position=bytes.length-4;
			var len:int=bytes.readInt();
			
			bytes.position=0;
			
			var dBytes:ByteArray =new ByteArray();
			dBytes.writeBytes(bytes,0,len);
			
			var headBytes:ByteArray =new ByteArray();
			bytes.position=len;
			headBytes.writeBytes(bytes,bytes.position,bytes.bytesAvailable);
			
			
			var i:int=0;
			var etype:EAmf3Type=null;
			
			
			var types:Array=[];
			var models:Array=[];
			var bodyNames:Array=[];
			
			//关键字长度
			dBytes.position=0;
			var bodyLen:int=dBytes.readInt();
			for(i=0;i<bodyLen;i++){
				bodyNames.push(dBytes.readUTF());
			}
			//数据长度
			bodyLen=dBytes.readInt();
			
			for(i=0;i<bodyLen;i++){
				var model:Array=[];
				for(var k:int=0;k<bodyNames.length;k++){
					etype=EAmf3Type.getEAmf3TypeById(dBytes.readByte());
					types.push(etype.type);
					model.push(etype.readFunction.apply(null,[dBytes]));
				}
				models.push(model);
			}
			
			//表头信息解析
			headBytes.position=0;
			var indexs:Array=[];
			var descrs:Array=[];
			var port:int=headBytes.readByte();
			
			//头部模板
			var keys:Array=[];
			var keysLen:int=headBytes.readInt();
			for (i = 0; i < keysLen; i++) 
			{
				keys.push(headBytes.readUTF());
			}
			
			bodyLen=headBytes.readInt();
			var typeId:int=-1;
			for (i = 0; i < bodyLen; i++) 
			{
				typeId=headBytes.readByte();
				etype=EAmf3Type.getEAmf3TypeById(typeId);
				indexs.push(etype.readFunction.apply(null,[headBytes]));
				
				typeId=headBytes.readByte();
				etype=EAmf3Type.getEAmf3TypeById(typeId);
				descrs.push(etype.readFunction.apply(null,[headBytes]));
			}
			
			var exportName:String=file.name;
			FactoryManager.instance().exportFormat(port,exportName.split(".")[0],bodyNames,indexs,types,models,descrs);
			
			EventManager.instance().dispatcherWithEvent(EventType.GET_LOG_MSG,">>>>>>完成处理文件："+file.nativePath);
			EventManager.instance().dispatcherWithEvent(EventType.FILE_PASER_COMPLETE);
		}
	}
}