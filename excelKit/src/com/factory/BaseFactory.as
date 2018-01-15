package com.factory
{
	import com.data.GlobalData;
	
	import flash.filesystem.File;
	
	public class BaseFactory implements IBaseFactroy
	{
		protected var _data:GlobalData;
		
		protected var serverBool:Boolean;
		protected var clientBool:Boolean;
		public function BaseFactory()
		{
			_data=GlobalData.instance();
		}
		
		public function parseFile(file:File):void
		{
			serverBool=_data.server_formats>0;
			clientBool=_data.client_formats>0;
		}
	}
}