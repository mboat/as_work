package com.amf3
{
	import com.data.core.HashMap;
	
	import flash.utils.ByteArray;

	public class EAmf3Type
	{
		private static var index:int=0;
		private static var dict:HashMap=new HashMap();
		
		
		public var id:uint;
		public var key:String;
		public var writeFunction:Function;
		public var readFunction:Function;
		public var initData:*;
		public var codes:Array=[];
		public function EAmf3Type(sn:uint,word:String,writefun:Function,readfun:Function,value:*,...params)
		{
			id=sn;
			key=word;
			writeFunction=writefun;
			readFunction=readfun;
			initData=value;
			codes=params;
			dict.put(id,this);
		}
		/**
		 * 类型字符串 
		 * @param key
		 * @return 
		 * 
		 */		
		public static function getEAmf3TypeByKey(key:String):EAmf3Type{
			return EAmf3Type["AMF_"+key.toLocaleLowerCase()];
		}
		
		/**
		 *object类型
		 */		
		public static const AMF_object:EAmf3Type=new EAmf3Type(index++,"object",writeObject,readObject,null,"Object");
		public static function writeObject(bytes:ByteArray,value:String=null):void{
			bytes.writeByte(AMF_object.id);
			bytes.writeUTF(value);
		}
		public static function readObject(bytes:ByteArray):Object{
			var str:String=bytes.readUTF();
			return JSON.parse(str);
		}
//		/**
//		 *任意类型
//		 */		
//		public static var AMF_any:EAmf3Type=new EAmf3Type(index++,"any",writeAny,readAny,null,"*");
//		public static function writeAny(bytes:ByteArray,value:*=null):void{
//			bytes.writeByte(AMF_any.id);
//			bytes.writeUTF(value);
//		}
//		public static function readAny(bytes:ByteArray):*{
//			return bytes.readUTF();
//		}
		
		/**
		 *字节
		 */		
		public static const AMF_byte:EAmf3Type=new EAmf3Type(index++,"byte",writeByte,readByte,0,"int");
		public static function writeByte(bytes:ByteArray,value:int):void{
			bytes.writeByte(AMF_byte.id);
			bytes.writeByte(value);
		}
		public static function readByte(bytes:ByteArray):int{
			return bytes.readByte();
		}
		
		/**
		 *布尔
		 */		
		public static const AMF_boolean:EAmf3Type=new EAmf3Type(index++,"boolean",writeBoolean,readBoolean,false,'Boolean');
		public static function writeBoolean(bytes:ByteArray,value:Boolean):void{
			bytes.writeByte(AMF_boolean.id);
			bytes.writeBoolean(value);
		}
		public static function readBoolean(bytes:ByteArray):Boolean{
			return bytes.readBoolean()
		}
		
		/**
		 *整型
		 */		
		public static const AMF_integer:EAmf3Type=new EAmf3Type(index++,"integer",writeInteger,readInteger,0,'int');
		public static function writeInteger(bytes:ByteArray,value:int):void{
			bytes.writeByte(AMF_integer.id);
			bytes.writeInt(value);
		}
		public static function readInteger(bytes:ByteArray):int{
			return bytes.readInt();
		}
		
		/**
		 *字符串
		 */		
		public static const AMF_string:EAmf3Type=new EAmf3Type(index++,"string",writeUTF,readUTF,null,'String');
		public static function writeUTF(bytes:ByteArray,value:String):void{
			bytes.writeByte(AMF_string.id);
			bytes.writeUTF(value);
		}
		public static function readUTF(bytes:ByteArray):String{
			return bytes.readUTF();
		}
		
	}
}