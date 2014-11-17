<?php
class data_custom extends def_module {
	/*
		возвращает дату в необходимом формате, имеет возможность расширяться для вывода русских дат
		Пример вывода <xsl:value-of select="document(concat('udata://data/dateru/',.//property[@name = 'publish_time']/value/@unix-timestamp))/udata"/>
		В данный момент использование параметра @format, не работает
	*/
	public function dateru($time=NULL,$format=NULL) {
		$allowDateFormat = array('d','n','Y','months_ru');
		$months_ru = array(1 => 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря');
		
		if(!$time) $time=time();
		if(!$format) $format="%d% %months_ru% %Y%";
		
		$sTemplate  = str_replace(array("&#037;", "&#37;"), "%", $format);
		preg_match_all("/%[A-z0-9_]+%/", $sTemplate, $aMarks);
		//var_dump($aMarks);
		foreach($aMarks[0] as $sMark){
			$param=str_replace("%", "", $sMark);
			if(in_array($param,$allowDateFormat)){
				if($param=='months_ru'){
					$month = date('n', $time);
					$sTemplate = str_replace($sMark,  $months_ru[$month], $sTemplate);
				}/* elseif($param=='Y'){
					$year = date('Y', $time);
					if($year == date('Y')) $year_val = '';
					else $year_val = $year.' года.';
					$sTemplate = str_replace($sMark,  $year_val, $sTemplate);
				} */else {
					$sTemplate = str_replace($sMark,  date($param, $time), $sTemplate);
				}
			}
		}
		return $sTemplate;
	}
	
};
?>