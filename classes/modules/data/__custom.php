<?php
	abstract class __custom_data {
        /**
        * @desc Format the number in desired way
        * @param Number  $_Number    Number to format
        * @param Integer $_Decimals	 Number of decimal signs
        * @param Char    $_DecPoint  Delimiter of the decimals
        * @param Char    $_Separator Separator between thousand groups
        * @return String Formatted number	
        */
        function numberformat($_Number, $_Decimals = 2, $_DecPoint = '.', $_Separator = ' ') {
            die( strval($_Number) );
            return number_format($_Number, $_Decimals, $_DecPoint, $_Separator);
        }
		
		public function uploadImageAdmin(){
			$this->__loadLib("__files.php");
			$this->__implement("__files_data");
			$this->flushAsXml('uploadImageAdmin');

			$thisCWD = $this->setupCwd();

			$quota_byte = getBytesFromString( mainConfiguration::getInstance()->get('system', 'quota-files-and-images') );
			if ( $quota_byte != 0 ) {
				$all_size = getBusyDiskSize(array('/files', '/images'));
				if ( $all_size >= $quota_byte ) {
					return array(
						'attribute:folder'	=> substr($thisCWD, strlen(CURRENT_WORKING_DIR)),
						'attribute:upload'	=> 'error',
						'nodes:error'		=> array('Ошибка: превышено ограничение на размер дискового пространства')
					);
				}
			}

			if (is_demo()) {
				return array(
					'attribute:folder'	=> substr($thisCWD, strlen(CURRENT_WORKING_DIR)),
					'attribute:upload'	=> 'done',
				);
			}

			if (isset($_FILES['Filedata']['name'])) {
				foreach($_FILES['Filedata'] as $k => $v) {
					$_FILES['Filedata'][$k] = array('upload' => $v);
				}
				$file = umiFile::upload('Filedata', 'upload', $thisCWD);
			} elseif (isset($_REQUEST['filename'])) {
				$file = umiFile::upload(false, false, $thisCWD);
			}
			
			$cwd = substr($thisCWD, strlen(CURRENT_WORKING_DIR));
			$result = array(
				'attribute:folder'	=> $cwd,
				'attribute:upload'	=> 'done',
			);

			if ($file) {

				$item = $thisCWD . "/" . $file->getFileName();

				// Collect some file info
				$imageExt = array("jpg", "jpeg", "gif", "png");
				$sizeMeasure = array("b", "Kb", "Mb", "Gb", "Tb");

				$name = $file->getFileName();
				$type = strtolower($file->getExt());
				$ts   = $file->getModifyTime();
				$time = date('g:i, d.m.Y' , $ts );
				$size = $file->getSize();
				$path = $file->getFilePath(true);
				$imagesOnly = in_array($type, $imageExt);

				if ($imagesOnly && !in_array($type, $imageExt)) {
					unlink($item);
					return $result;
				}

				$file = array(
					'attribute:name' => $name,
					'attribute:type' => $type,
					'attribute:size' => $size,
					'attribute:ctime'     => $time,
					'attribute:timestamp' => $ts,
					'attribute:path' => $path
				);
				if ($imagesOnly) {
					$content = cmsController::getInstance()->getModule("content");
					$this->__implement("content_custom");
					
					$thumbs_path = ".".$cwd;
					$thumg = $this->makeThumbnailCare(".".$path, 'auto', 100, "default", true, false, true, $thumbs_path);
					$file['attribute:path_thumg'] = $thumg['src'];
				}

				$i = 0;
				while ($size > 1024.0) {
					$size /= 1024;
					$i++;
				}
				$convertedSize = (int)round($size);
				if ($convertedSize == 1 && (int)floor($size) != $convertedSize) {
					$i++;
				}
				$file['attribute:converted-size']   = $convertedSize.$sizeMeasure[$i];
				if (in_array($type, $imageExt)) {
					if ($info = @getimagesize($item)) {
						umiImageFile::addWatermark("." . $cwd . "/" . $name);

						$file['attribute:mime']   = $info['mime'];
						$file['attribute:width']  = $info[0];
						$file['attribute:height'] = $info[1];
					} else {
						unlink($item);
						return $result;
					}
				}

				$result["file"] = $file;
			}

			return $result;
		}
		
	};
?>