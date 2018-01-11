package com.factory
{
	import com.as3xls.xls.Sheet;
	import com.event.EventManager;
	import com.event.EventType;

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
		public var format:int=0;
		/**
		 *输出端 
		 */		
		public var port:int=1;
		public function BaseProduct()
		{
		}
		
		/**
		 * 执行解析 
		 * @param port 输出方
		 * @param sheet 工作簿数据
		 * @param names 头部字段数组
		 * @param typeIndex  type类型所在的index
		 * @param colIndexs  属于字段的index组
		 * @param rowIds     条目item的index组
		 * 
		 */			
		public function exec(port:int,sheet:Sheet,names:Array=null,typeIndex:int=-1,colIndexs:Array=null,rowIds:Array=null):void{
			status=0;
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