<?php
	abstract class __data_custom_admin {
		//TODO: Write here your own macroses (admin mode)
		
		public function uploadfilenew() {
			$this->flushAsXml('uploadfilenew');
			$this->setupCwd();

			$quota_byte = getBytesFromString( mainConfiguration::getInstance()->get('system', 'quota-files-and-images') );
			if ( $quota_byte != 0 ) {
				$all_size = getBusyDiskSize(array('/files', '/images'));
				if ( $all_size >= $quota_byte ) {
					return array(
						'@folder'	=> substr($this->cwd, strlen(CURRENT_WORKING_DIR)),
						'@upload'	=> 'error',
						'nodes:error'		=> array('Ошибка: превышено ограничение на размер дискового пространства')
					);
				}
			}

			if (is_demo()) {
				return array(
					'@folder'	=> substr($this->cwd, strlen(CURRENT_WORKING_DIR)),
					'@upload'	=> 'done',
				);
			}

			if (isset($_FILES['Filedata']['name'])) {
				foreach($_FILES['Filedata'] as $k => $v) {
					$_FILES['Filedata'][$k] = array('upload' => $v);
				}
				$file = umiFile::upload('Filedata', 'upload', $this->cwd);
			} elseif (isset($_REQUEST['filename'])) {
				$file = umiFile::upload(false, false, $this->cwd);
			}

			$cwd = substr($this->cwd, strlen(CURRENT_WORKING_DIR));
			$result = array(
				'@folder'	=> $cwd,
				'@upload'	=> 'done',
			);

			if ($file) {

				$item = $this->cwd . "/" . $file->getFileName();

				// Collect some file info
				$imageExt = array("jpg", "jpeg", "gif", "png");
				$sizeMeasure = array("b", "Kb", "Mb", "Gb", "Tb");

				$name = $file->getFileName();
				$type = strtolower($file->getExt());
				$ts   = $file->getModifyTime();
				$time = date('g:i, d.m.Y' , $ts );
				$size = $file->getSize();
				$path = $file->getFilePath(true);
				$images = in_array($type, $imageExt);

				if (isset($_REQUEST['imagesOnly']) && !$images) {
					unlink($item);
					return $result;
				}

				$file = array(
					'@name' => $name,
					'@type' => $type,
					'@size' => $size,
					'@ctime'     => $time,
					'@timestamp' => $ts,
					'@path' => $path
				);

				$i = 0;
				while ($size > 1024.0) {
					$size /= 1024;
					$i++;
				}
				$convertedSize = (int)round($size);
				if ($convertedSize == 1 && (int)floor($size) != $convertedSize) {
					$i++;
				}
				$file['@converted-size']   = $convertedSize.$sizeMeasure[$i];
				$file['@image'] = $images;
				if ($images) {
					if ($info = @getimagesize($item)) {
						if(isset($_REQUEST['imagesOnly'])){
							$thumbs_path = ".".$cwd;
							$content = cmsController::getInstance()->getModule("content");
							$content->__implement("content_custom");
							$thumg = $content->makeThumbnailCare(".".$path, 'auto', 100, "default", true, false, true, $thumbs_path);
							$file['@path_thumg'] = $thumg['src'];
						}
						
						umiImageFile::addWatermark("." . $cwd . "/" . $name);

						$file['@mime']   = $info['mime'];
						$file['@width']  = $info[0];
						$file['@height'] = $info[1];
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