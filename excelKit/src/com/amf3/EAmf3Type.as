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
		public static const AMF_object:EAmf3Type=new EAmf3Type(index++,"object",writeObject,readObject,null,"Object","any");
		public static function writeObject(bytes:ByteArray,value:String=null):void{
			bytes.writeByte(AMF_object.id);
			bytes.writeUTF(value);
		}
		public static function readObject(bytes:ByteArray):Object{
			var str:String=bytes.readUTF();
			return JSON.parse(str);
		}
		
		/**
		 *任意类型
		 */		
		public static var AMF_any:EAmf3Type=new EAmf3Type(index++,"any",writeAny,readAny,null,"*",'any');
		public static function writeAny(bytes:ByteArray,value:String=null):void{
			bytes.writeByte(AMF_any.id);
			bytes.writeUTF(value);
		}
		public static function readAny(bytes:ByteArray):*{
			var str:String=bytes.readUTF();
			return JSON.parse(str);
		}
		
		/**
		 *字节
		 */		
		public static const AMF_byte:EAmf3Type=new EAmf3Type(index++,"byte",writeByte,readByte,0,"int",'number');
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
		public static const AMF_boolean:EAmf3Type=new EAmf3Type(index++,"boolean",writeBoolean,readBoolean,false,'Boolean','boolean');
		public static function writeBoolean(bytes:ByteArray,value:Boolean):void{
			bytes.writeByte(AMF_boolean.id);
			bytes.writeBoolean(value);
		}
		public static function readBoolean(bytes:ByteArray):Boolean{
			return bytes.readBoolean()
		}
		
		/**
		 *integer整型
		 */		
		public static const AMF_integer:EAmf3Type=new EAmf3Type(index++,"integer",writeInteger,readInteger,0,'int','number');
		public static function writeInteger(bytes:ByteArray,value:int):void{
			bytes.writeByte(AMF_integer.id);
			bytes.writeInt(value);
		}
		public static function readInteger(bytes:ByteArray):int{
			return bytes.readInt();
		}
		
		/**
		 *int整型
		 */		
		public static const AMF_int:EAmf3Type=new EAmf3Type(index++,"int",writeInteger,readInteger,0,'int','number');
		public static function writeInt(bytes:ByteArray,value:int):void{
			bytes.writeByte(AMF_int.id);
			bytes.writeInt(value);
		}
		public static function readInt(bytes:ByteArray):int{
			return bytes.readInt();
		}
		
		/**
		 *字符串
		 */		
		public static const AMF_string:EAmf3Type=new EAmf3Type(index++,"string",writeUTF,readUTF,null,'String','string');
		public static function writeUTF(bytes:ByteArray,value:String):void{
			bytes.writeByte(AMF_string.id);
			bytes.writeUTF(value);
		}
		public static function readUTF(bytes:ByteArray):String{
			return bytes.readUTF();
		}
		
		/**
		 * number类型
		 */		
		public static const AMF_number:EAmf3Type=new EAmf3Type(index++,"number",writeNumber,readNumber,null,'Number','number');
		public static function writeNumber(bytes:ByteArray,value:Number):void{
			bytes.writeByte(AMF_number.id);
			bytes.writeDouble(value);
		}
		public static function readNumber(bytes:ByteArray):Number{
			return bytes.readDouble();
		}
		
		/**
		 * double类型
		 */		
		public static const AMF_double:EAmf3Type=new EAmf3Type(index++,"double",writeDouble,readDouble,null,'Number','number');
		public static function writeDouble(bytes:ByteArray,value:Number):void{
			bytes.writeByte(AMF_double.id);
			bytes.writeDouble(value);
		}
		public static function readDouble(bytes:ByteArray):Number{
			return bytes.readDouble();
		}
		
		/**
		 * float类型
		 */		
		public static const AMF_float:EAmf3Type=new EAmf3Type(index++,"float",writeFloat,readFloat,null,'Number','number');
		public static function writeFloat(bytes:ByteArray,value:Number):void{
			bytes.writeByte(AMF_float.id);
			bytes.writeFloat(value);
		}
		public static function readFloat(bytes:ByteArray):Number{
			return bytes.readFloat();
		}
		
		/**
		 * short类型
		 */		
		public static const AMF_short:EAmf3Type=new EAmf3Type(index++,"short",writeShort,readShort,null,'int','number');
		public static function writeShort(bytes:ByteArray,value:int):void{
			bytes.writeByte(AMF_short.id);
			bytes.writeShort(value);
		}
		public static function readShort(bytes:ByteArray):int{
			return bytes.readShort();
		}
		
	}
}