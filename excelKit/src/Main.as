import com.type.OutPutType;

import flash.events.Event;

import spark.components.CheckBox;
import spark.components.TextArea;

// ActionScript file
/**
 *保存配置文件 
 */
private function saveCfg():void{
	var path:String =_root+_cfgpath;
	FileUtil.saveFile(path,_cfgXml.toXMLString());
}
/**
 *检测配置 
 */
private function checkCfg():void{
	_root =File.applicationDirectory.nativePath;
	
	var path:String =_root+_cfgpath;
	var cfgFile:File =new File(path);
	_cfgXml=new XML(FileUtil.readByUTFBytes(cfgFile));
	
	showInfo();
	
	path=_cfgXml.dir.sheet;
	checkPath(path,browseSheetDirComplete);
}

/**
 *展示配置信息 
 */
private function showInfo():void{
	var list:XMLList =_cfgXml.elements("dir").children();
	for(var key:String in list){
		var xml:XML=list[key];
		var txt:TextArea=this["txt_"+xml.name()+"_dir"];
		if(txt){
			txt.text=xml.text();
		}
	}
	
	var cfgValue:int=_cfgXml.elements('format').text();
	var len:int=_data.formatLen;
	var i:int=0,result:int;
	for(i=0;i<len;i++){
		result=cfgValue>>(len-i-1)&1;
		CheckBox(this["box_"+i]).selected=result>0?true:false;
	}
	_data.format=cfgValue;
	
	cfgValue=_cfgXml.elements('export').text();
	len=_data.exportLen;
	for(i=0;i<len;i++){
		result=cfgValue>>(len-i-1)&1;
		CheckBox(this["export_"+i]).selected=result>0?true:false;
	}
	_data.export=cfgValue;
	
}

/**
 * 检测路径是否正确
 */
private function checkPath(path:String,backFun:Function):void{
	var loadFile:Boolean=false;
	if(path&&path.length>0){
		if(path.indexOf(".")==0){
			path=path.replace(".",_root);
		}
		var tempfile:File=new File(path);
		if(tempfile.exists==false){
			loadFile=true;
		}else{
			backFun(tempfile,false);
			return;
		}
	}else{
		loadFile=true;
	}
	if(loadFile){
		FileUtil.browseForDirectory(browseComplete);
	}
	
	function browseComplete(file:File):void{
		backFun(file,true);
	}
}


/**
 *选择完成表格所在目录 
 */
private function browseSheetDirComplete(file:File,savebool:Boolean=true):void{
	_data.sheetDir=file;
	txt_sheet_dir.text=file.nativePath;
	if(savebool){
		_cfgXml.dir.sheet=file.nativePath;
		saveCfg();
	}
}

/**
 *当前点击浏览的按钮 
 */
private var _browseBtn:Button;
/**
 * 点击所有浏览按钮的处理事件函数
 */
protected function btnBrowseDirHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	_browseBtn=event.currentTarget as Button;
	if(_browseBtn){
		FileUtil.browseForDirectory(browseDirComplete);
	}
	
}

/**
 *选择完成表格所在目录 
 */
private function browseDirComplete(file:File):void{
	
	switch(_browseBtn){
		case btn_sheet_dir:
			_data.sheetDir=file;
			txt_sheet_dir.text=file.nativePath;
			_cfgXml.dir.sheet=file.nativePath;
			break;
		case btn_bin_dir:
			_data.outDict[OutPutType.BIN]=file;
			txt_bin_dir.text=file.nativePath;
			_cfgXml.dir.bin=file.nativePath;
			break;
		case btn_xml_dir:
			_data.outDict[OutPutType.XML]=file;
			txt_xml_dir.text=file.nativePath;
			_cfgXml.dir.xml=file.nativePath;
			break;
		case btn_json_dir:
			_data.outDict[OutPutType.JSON]=file;
			txt_json_dir.text=file.nativePath;
			_cfgXml.dir.json=file.nativePath;
			break;
		case btn_code_dir:
			_data.outDict[OutPutType.CODE]=file;
			txt_code_dir.text=file.nativePath;
			_cfgXml.dir.code=file.nativePath;
			break;
	}
	saveCfg();
}
/**
 *选择输出格式处理函数 
 */
private function selectformatHandler(evt:Event):void{
	var format:String="";
	var len:int=_data.formatLen;
	for(var i:int=0;i<len;i++){
		format+=(this["box_"+i] as CheckBox).selected?1:0;
	}
	
	_data.format=parseInt(format,2);
	
	_cfgXml.format=_data.format;
	saveCfg();
}
/**
 *选择导出端的文件 
 */
private function selectExportHandler(evt:Event):void{
	var export:String="";
	var len:int=_data.exportLen;
	for(var i:int=0;i<len;i++){
		export+=(this["export_"+i] as CheckBox).selected?1:0;
	}
	_data.export=parseInt(export,2);
	
	_cfgXml.export=_data.export;
	saveCfg();
}

private function startHandler(evt:Event=null):void{
	
}
