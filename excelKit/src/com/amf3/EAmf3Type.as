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
		public var defaultContent:*;
		public function EAmf3Type(sn:uint,word:String,writefun:Function,readfun:Function,value:*=null)
		{
			id=sn;
			key=word;
			writeFunction=writefun;
			readFunction=readfun;
			defaultContent=value;
			dict[id]=this;
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
		 *空 
		 */		
		public static var AMF_null:EAmf3Type=new EAmf3Type(index++,"null",writeNull,readNull);
		public static function writeNull(bytes:ByteArray,value:*=null):void{
			bytes.writeByte(AMF_null.id);
		}
		public static function readNull(bytes:ByteArray):*{
			return AMF_null.defaultContent;
		}
		
		/**
		 *字节
		 */		
		public static var AMF_byte:EAmf3Type=new EAmf3Type(index++,"byte",writeByte,readByte,0);
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
		public static var AMF_boolean:EAmf3Type=new EAmf3Type(index++,"boolean",writeBoolean,readBoolean,false);
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
		public static var AMF_integer:EAmf3Type=new EAmf3Type(index++,"integer",writeInteger,readInteger,false);
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
		public static var AMF_string:EAmf3Type=new EAmf3Type(index++,"string",writeUTF,readUTF);
		public static function writeUTF(bytes:ByteArray,value:String):void{
			bytes.writeByte(AMF_string.id);
			bytes.writeUTF(value);
		}
		public static function readUTF(bytes:ByteArray):String{
			return bytes.readUTF();
		}
		
	}
}