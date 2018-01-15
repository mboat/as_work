package com.factory
{
	import flash.filesystem.File;

	public interface IBaseFactroy
	{
		function parseFile(file:File):void;
	}
}