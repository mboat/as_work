package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.event.EventManager;
	import com.event.EventType;
	import com.type.CommonConst;

	public class BaseProduct
	{
		protected var content:*;
		/**
		 * 状态：-1.初始，0.进行重，1.完成 
		 */		
		protected var status:int=-1;
		/**
		 *输出类型 
		 */		
		public var type:int=0;
		
		protected var clientBool:Boolean;
		protected var serverBool:Boolean;
		public function BaseProduct()
		{
		}
		/**
		 * 执行函数 
		 * @param sheet
		 * 
		 */		
		public function exec(sheetInfo:Object,port:int=1):void{
			status=0;
			serverBool=port&CommonConst.EXPORT_SERVER;
			clientBool=port&CommonConst.EXPORT_CLIENT;
		}
		/**
		 *完成函数 
		 * 
		 */		
		protected function complete():void{
			status=1;
		}
		
		public function recover():void{
			EventManager.instance().dispatcherWithEvent(EventType.GET_RECOVER,this);
		}
		
		/**
		 * 获取当前的数据集 
		 * @return 
		 * 
		 */		
		public function getProducts():*{
			
			return content;
		}
		/**
		 * 获取状态 
		 * @return 
		 * 
		 */		
		public function getStatus():int{
			return status;
		}
		/**
		 *重置数据 
		 * 
		 */		
		public function reset():void{
			content=null;
			status=-1;
		}
	}
}