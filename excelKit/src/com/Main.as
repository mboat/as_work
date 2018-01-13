import com.event.DataEvent;
import com.event.EventManager;
import com.event.EventType;
import com.factory.FactoryManager;
import com.type.CommonConst;

import flash.events.Event;
import flash.filesystem.File;

import mx.controls.Alert;

import spark.components.CheckBox;
import spark.components.RadioButton;
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
	var list:XMLList =_cfgXml.elements(CommonConst.CFG_DIR).children();
	
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
	
	var len:int=_data.formatLen;
	var i:int=0,result:int=0;
	var cfgValue:int=0;
	
	//数据源格式
	cfgValue=_cfgXml.elements(CommonConst.ORIGIN_FORMAT).text();
	for(i=0;i<len;i++){
		RadioButton(this["org_1"+i]).selected=(cfgValue==i);
	}
	_data.origin_format=cfgValue;
	
	
	//前端输出各个格式值
	cfgValue=_cfgXml.elements(CommonConst.CLIENT_FORMATS).text();
	_data.client_formats=cfgValue;
	//后端
	cfgValue=_cfgXml.elements(CommonConst.SERVER_FORMATS).text();
	_data.server_formats=cfgValue;
	
	//code的类路径	
	_data.class_path=_cfgXml.elements(CommonConst.CLASS_PATH).text();
	txt_class_path.text=_data.class_path;
	
	updateExportUI();
}

private function updateExportUI(inited:Boolean=true):void{
	var len:int=_data.formatLen;
	var i:int=0,result:int=0;
	var cfgValue:int=0;
	
	var formats:Array=_data.getOriginFormats(_data.origin_format);
	//前端输出各个格式值
	cfgValue=_data.client_formats;
	var tempBox:CheckBox=null;
	for(i=0;i<len;i++){
		tempBox=CheckBox(this["box_1"+i]);
		tempBox.enabled=formats.indexOf(i)>=0;
		if(inited&&tempBox.enabled){
			result=cfgValue>>(len-i-1)&1;
			tempBox.selected=result>0?true:false;
		}else{
			tempBox.selected=false;
		}
	}
	
	//后端
	cfgValue=_data.server_formats;
	for(i=0;i<len;i++){
		tempBox=CheckBox(this["box_2"+i]);
		tempBox.enabled=formats.indexOf(i)>=0;
		if(inited&&tempBox.enabled){
			result=cfgValue>>(len-i-1)&1;
			tempBox.selected=result>0?true:false;
		}else{
			tempBox.selected=false;
		}
	}
}

///**
// * 检测路径是否正确
// */
//private function checkPath(path:String):Boolean{
//	if(path&&path.length>0){
//		if(path.indexOf(".")==0){
//			path=path.replace(".",_root);
//		}
//		var tempfile:File=new File(path);
//		if(tempfile.exists==false){
//			return false;
//		}
//	}
//	return true;
//}
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
private function browseOrgDirComplete(file:File,savebool:Boolean=true):void{
	_data.filesDict[CommonConst.ORIGIN_DIR]=file;
	txt_origin_dir.text=file.nativePath;
	if(savebool){
		_cfgXml.dir[CommonConst.ORIGIN_DIR]=file.nativePath;
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
		case btn_origin_dir:
			_data.filesDict[CommonConst.ORIGIN_DIR]=file;
			txt_origin_dir.text=file.nativePath;
			_cfgXml[CommonConst.CFG_DIR][CommonConst.ORIGIN_DIR]=file.nativePath;
			break;
		case btn_output_dir:
			_data.filesDict[CommonConst.OUTPUT_DIR]=file;
			txt_output_dir.text=file.nativePath;
			_cfgXml[CommonConst.CFG_DIR][CommonConst.OUTPUT_DIR]=file.nativePath;
			break;
		case btn_code_dir:
			_data.filesDict[CommonConst.CODE_DIR]=file;
			txt_code_dir.text=file.nativePath;
			_cfgXml[CommonConst.CFG_DIR][CommonConst.CODE_DIR]=file.nativePath;
			break;
	}
	saveCfg();
}

/**
 *选择输出格式处理函数 
 */
private function clientFormatHandler(evt:Event):void{
	var format:String="";
	var len:int=_data.formatLen;
	for(var i:int=0;i<len;i++){
		format+=(this["box_1"+i] as CheckBox).selected?1:0;
	}
	
	_data.client_formats=parseInt(format,2);
	
	_cfgXml[CommonConst.CLIENT_FORMATS]=_data.client_formats;
}

/**
 *选择输出格式处理函数 
 */
private function serverFormatsHandler(evt:Event):void{
	var format:String="";
	var len:int=_data.formatLen;
	for(var i:int=0;i<len;i++){
		format+=(this["box_2"+i] as CheckBox).selected?1:0;
	}
	
	_data.server_formats=parseInt(format,2);
	
	_cfgXml[CommonConst.SERVER_FORMATS]=_data.server_formats;
}

/**
 *选择输出格式处理函数 
 */
private function originFormatHandler(evt:Event):void{
	var len:int=_data.formatLen;
	for(var i:int=0;i<len;i++){
		var radioBtn:RadioButton=(this["org_1"+i] as RadioButton);
		if(radioBtn==evt.currentTarget){
			_data.origin_format=i;
			radioBtn.selected=true;
		}else{
			radioBtn.selected=false;
		}
	}
	_cfgXml[CommonConst.ORIGIN_FORMAT]=_data.origin_format;
	
	updateExportUI();
}


private function operateClassPathHandler(evt:Event):void{
	txt_class_path.editable=!txt_class_path.editable;
	if(txt_class_path.editable){
		btn_class_path.label="保存";
	}else{
		btn_class_path.label="编辑";
		_data.class_path=txt_class_path.text;
		_cfgXml[CommonConst.CLASS_PATH]=_data.class_path;
		saveCfg();
	}
}

private function startHandler(evt:Event=null):void{
	saveCfg();
	
	var temp:File=_data.filesDict[CommonConst.ORIGIN_DIR];
	if(temp==null||temp.exists==false){
		Alert.show("请选择配置目录");
		return;
	}
	
	temp=_data.filesDict[CommonConst.OUTPUT_DIR];
	if(temp==null||temp.exists==false){
		Alert.show("请选择输出目录");
		return;
	}
	if((_data.client_formats&1)){
		temp=_data.filesDict[CommonConst.CODE_DIR];
		if(temp==null||temp.exists==false){
			Alert.show("请选择code输出目录");
			return;
		}
	}
	
	if(_data.client_formats<=0&&_data.server_formats<=0){
		Alert.show("选择输出格式和输出方");
		return;
	}

	startup();
}

private function startup():void{
	EventManager.instance().register(EventType.ADD_LIST,addListHandler);
	EventManager.instance().register(EventType.GET_LOG_MSG,logHandler);
	EventManager.instance().register(EventType.FILE_PASER_COMPLETE,oneFileComplete);
	FactoryManager.instance().startup();
}

private var options:Array=[];
private var _running:Boolean=false;
private function onEnterFrame(evt:Event):void{
	if(_running==false&&options.length>0){
		_running=true;
		txt_log.appendText(">>>>>>已启动\n");
		if(_data.origin_format==CommonConst.EXCEL){
			FactoryManager.instance().paserExcel(options.shift());
		}
		else{
			txt_log.appendText(">>>>>>暂时开放该类数据源解析，格式类型："+_data.origin_format+"\n");
		}
		
	}
	if(options.length<=0){
		this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		_running=false;
		this.exit();
	}
}

private function oneFileComplete(evt:com.event.DataEvent):void{
	_running=false;
}

private var logs:Array=[];
private var maxLog:int=5000;
private function logHandler(evt:com.event.DataEvent):void{
	if(logs.length>maxLog){
		logs.shift();
	}
	var msg:String=evt.data+"\n";
	logs.push(msg);
	txt_log.appendText(msg);
}

private function addListHandler(evt:com.event.DataEvent):void{
	var list:Array=evt.data as Array;
	if(list){
		options=options.concat(list);
	}
	
	if(options.length>0){
		txt_log.appendText(">>>>>>启动处理事件\n");
		if(this.hasEventListener(Event.ENTER_FRAME)==false){
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
	}else{
		txt_log.appendText(">>>>>>当前选择的目录下，没有该类型的文件。\n");
	}
}
