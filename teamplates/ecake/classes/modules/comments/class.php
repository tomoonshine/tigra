<?php
	class comments_custom extends def_module {
	
		public function onCommentPostRating(iUmiEventPoint $event) {
			if($event->getMode() == 'after') {
				$commentId = $event->getParam('message_id');
				$parentId = $event->getParam('topic_id');
				

				$comment = umiHierarchy::getInstance()->getElement($commentId);
				
				$comment->rating_int = getRequest('rating_int');
				$comment->commit();
				
				$parent = umiHierarchy::getInstance()->getElement($parentId);
				if($parent instanceof umiHierarchyElement){
					$sel = new selector('pages');
					$sel->types('hierarchy-type')->name('comments', 'comment');
					$sel->where('hierarchy')->page($parentId)->childs(1);
					$total = $sel->length;
					$sum=0;
					foreach($sel as $page){
						$sum += $page->rating_int;
					}
					$rating = $sum/$total;
					$parent->summ_rating = $rating;
					$parent->commit();
				}
			}
		}
	};
?>