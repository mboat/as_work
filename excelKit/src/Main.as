import com.data.core.HashMap;
import com.type.GlobalConst;

import flash.events.Event;
import flash.filesystem.File;

import mx.controls.Alert;

import spark.components.CheckBox;
import spark.components.TextArea;

// ActionScript file
/**
 *保存配置文件 
 */
private function saveCfg():void{
	var path:String =_root+_cfgpath;
	XML.ignoreProcessingInstructions = false;
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
	
//	path=_cfgXml.dir.sheet;
//	checkPath(path,browseSheetDirComplete);
}

/**
 *展示配置信息 
 */
private function showInfo():void{
	var list:XMLList =_cfgXml.elements("dir").children();
	
	for(var key:String in list){
		var xml:XML=list[key];
		var type:String =xml.name();
		var path:String=xml.text();
		if(path&&path.length>0){
			if(path.indexOf(".")==0){
				path=path.replace(".",_root);
			}
			var tempfile:File=new File(path);
			if(tempfile.exists==false){
				continue;
			}else{
				_data.filesDict[type]=tempfile;
			}
		}
		var txt:TextArea=this["txt_"+type+"_dir"];
		if(txt){
			txt.text=path;
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
	
	_data.class_path=_cfgXml.elements('class_path').text();
	txt_class_path.text=_data.class_path;
}

/**
 * 检测路径是否正确
 */
private function checkPath(path:String):Boolean{
	if(path&&path.length>0){
		if(path.indexOf(".")==0){
			path=path.replace(".",_root);
		}
		var tempfile:File=new File(path);
		if(tempfile.exists==false){
			return false;
		}
	}
	return true;
}
///**
// * 检测路径是否正确
// */
//private function checkPath(path:String,backFun:Function):void{
//	var loadFile:Boolean=false;
//	if(path&&path.length>0){
//		if(path.indexOf(".")==0){
//			path=path.replace(".",_root);
//		}
//		var tempfile:File=new File(path);
//		if(tempfile.exists==false){
//			loadFile=true;
//		}else{
//			backFun(tempfile,false);
//			return;
//		}
//	}else{
//		loadFile=true;
//	}
//	if(loadFile){
//		FileUtil.browseForDirectory(browseComplete);
//	}
//	
//	function browseComplete(file:File):void{
//		backFun(file,true);
//	}
//}


/**
 *选择完成表格所在目录 
 */
private function browseSheetDirComplete(file:File,savebool:Boolean=true):void{
	_data.filesDict[GlobalConst.sheet]=file;
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
			_data.filesDict[GlobalConst.sheet]=file;
			txt_sheet_dir.text=file.nativePath;
			_cfgXml.dir.sheet=file.nativePath;
			break;
		case btn_output_dir:
			_data.filesDict[GlobalConst.output]=file;
			txt_output_dir.text=file.nativePath;
			_cfgXml.dir.output=file.nativePath;
			break;
		case btn_code_dir:
			_data.filesDict[GlobalConst.CODE]=file;
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

private function operateClassPathHandler(evt:Event):void{
	txt_class_path.editable=!txt_class_path.editable;
	if(txt_class_path.editable){
		btn_class_path.label="保存";
	}else{
		btn_class_path.label="编辑";
		_data.class_path=txt_class_path.text;
		_cfgXml.class_path=_data.class_path;
		saveCfg();
	}
}

private function startHandler(evt:Event=null):void{
	var temp:File=_data.filesDict[GlobalConst.sheet];
	if(temp==null||temp.exists==false){
		Alert.show("请选择配置目录");
		return;
	}
	
	temp=_data.filesDict[GlobalConst.output];
	if(temp==null||temp.exists==false){
		Alert.show("请选择输出目录");
		return;
	}
	if(_data.format<=0){
		Alert.show("请选择输出格式");
		return;
	}
	if(_data.format&1){
		temp=_data.filesDict[GlobalConst.CODE];
		if(temp==null||temp.exists==false){
			Alert.show("请选择code输出目录");
			return;
		}
	}
	if(_data.export<=0){
		Alert.show("请选择输出端");
		return;
	}
	
	
	trace("start appliction")
}
