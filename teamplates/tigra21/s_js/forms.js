site.forms = {};

/**
 * Добавляет события формам
 */
site.forms.init = function () {
	var elements_arr = jQuery('.required input, .required textarea, .required select');
	var element, i;
	for (i = 0; elements_arr.length > i; i++) {
		element = elements_arr[i];
		element.onchange = site.forms.errors.show(element, i);
	}
	site.forms.data.restore();
	site.forms.comments.init();
	if (location.href.indexOf('forget') != -1) {
		jQuery('#forget input:radio').click(function() {
			jQuery('#forget input:text').attr('name', jQuery(this).attr('id'));
		});
	}
};

site.forms.data = {};

/**
 * Проверка корректности заполнения формы
 *
 * @param {Object} form Проверяемая форма
 * @param {Number} num Позиция элемента
 * @return {Boolean} Результат корректности заполнения
 */
site.forms.data.check = function (form, num) {
	var r = num, elements_arr = jQuery('.required input, .required textarea, .required select', form).not('.required input[type="search"], .other-field-address .required input, .other-field-address .required textarea, .other-field-address .required select');;
	++r;
	for (var i = 0; elements_arr.length > i; i++) {
		if (typeof num != "undefined" && elements_arr[r] == elements_arr[i]) return false;
		if (!site.forms.errors.check(elements_arr[i], num)) return false;
	}
    return true;
};

site.forms.data.save = function (form) {
	if (!form && !form.id) return false;
	var str = "", input, inputName, i, opt_str = "", o;
	for (i = 0; i < form.elements.length; i++) {
		input = form.elements[i];
		if (input.name) {
			inputName = input.name.replace(/([)\\])/g, "\\$1");
			switch (input.type) {
				case "password":break;
				case "text":
				case "textarea": str += 'TX,' + inputName + ',' + input.value; break;
				case "checkbox":
				case "radio": str += 'CH,' + input.id + ',' + (input.checked ? 1 : 0); break;
				case "select-one": str += 'SO,' + inputName + ',' + input.selectedIndex; break;
				case "select-multiple": {
					for (o = 0; o < input.options.length; o++) {
						if (input.options[o].selected) {
							opt_str += input.options[o].value;
							if (o < (input.options.length - 1)) opt_str += ":";
						}
					}
					str += 'SM,' + inputName + ',' + opt_str; break;
				}
			}
			if (i < (form.elements.length - 1)) str += "+";
		}
	}
	jQuery.cookie("frm" + form.id, str.replace(/([|\\])/g, "\\$1"));
	return true;
};

site.forms.data.restore = function () {
	var forms = jQuery('form'), i, j, element, data;
	for (i = 0; i < forms.length; i++) {
		if (forms[i].id && (data = jQuery.cookie("frm" + forms[i].id))) {
			data = data.split('+');
			for (j = 0; j < data.length; j++) {
				element = data[j].split(',');
				if (!element) continue;
				switch (element[0]) {
					case "PW": break;
					case "TX": forms[i].elements[element[1]].value = element[2]; break;
					case "CH": document.getElementById(element[1]).checked = (element[2] == 1) ? true : false; break;
					case "SO": forms[i].elements[element[1]].selectedIndex = element[2]; break;
					case "SM":
						var options = forms[i].elements[element[1]].options;
						var opt_arr = element[2].split(":"), op, o;
						for (op = 0; op < options.length; op++)
							for (o = 0; o < opt_arr.length; o++)
								if (opt_arr[o] && (options[op].value == opt_arr[o]))
									options[op].selected = true;
						break;
				}
			}
		}
	}
	return true;
};

site.forms.comments = {};

site.forms.comments.init = function() {
	var blog_comm = jQuery('#comments');
	var blog_comm_arr, i;
	if (typeof blog_comm[0] == 'object') {
		blog_comm_arr = jQuery('a.comment_add_link', blog_comm[0]);
		for (i = 0; blog_comm_arr.length > i; i++) {
			blog_comm_arr[i].onclick = site.forms.comments.add(blog_comm_arr[i]);
		}
	}
};

site.forms.comments.add = function(element) {
	return (function() {site.forms.comments.setAction(element.id);});
};

site.forms.comments.setAction = function(comm_id) {
	var comment_add_form;
	if ((comment_add_form = jQuery('#comment_add_form'))) {
		comment_add_form[0].action = '/blogs20/commentAdd/' + comm_id;
		return true;
	}
	return false;
};

site.forms.vote = function(form, vote_id) {
	var res = false;
	for (var i = 0; form.elements.length > i; i++)
		if (form.elements[i].checked)
			res = form.elements[i].value;
	if (res) {
		jQuery.ajax({
			url : '/vote/post/' + res + '/?m=' + new Date().getTime(),
			dataType: 'html',
			success: function(data){eval(data)}
		});
		jQuery.ajax({
			url: '/udata://vote/results/' + vote_id + '/?transform=modules/vote/results.xsl&m=' + new Date().getTime(),
			dataType: 'html',
			success: function(data){jQuery(form.parentNode).html(data)}
		});
	}
	else alert('Не выбран ни один вариант');
};

site.forms.errors = {};

site.forms.errors.show = function(element, num) {
	return (function(){site.forms.data.check(element.form, num)});
};

/**
 * Генерация ошибок
 *
 * @param {Object} element Проверяемый элемент формы
 * @param {Number} num Позиция элемента формы
 * @return {Boolean} Результат корректности заполнения
 */
site.forms.errors.check = function(element, num) {
	var _err, empty_err = "Поле обязательно для заполнения.";
	//var callback = function(transport){return (site.forms.errors.write(transport.responseText, element));};
	switch (element.name) {
		/*case "login": {
			switch (element.value.length) {
				case 0: _err = empty_err; break;
				case 1:
				case 2: _err = "Слишком короткий логин. Логин должен состоять не менее, чем из 3х символов."; break;
				default: {
					if (element.value.length > 40) _err = "Слишком большой логин. Логин должен состоять не более, чем из 40 символов.";
					//if (typeof num != 'undefined'); //checkUserLogin callback
				}
			}
			break;
		}*/
		case "password": {
			switch (element.value.length) {
				case 0: _err = empty_err; break;
				case 1:
				case 2: _err = "Слишком короткий пароль. Пароль должен состоять не менее, чем из 3х символов."; break;
				default: {
					if (element.form.elements['email'].value == element.value)
						_err = "Пароль не должен совпадать с логином.";
				}
			}
			break;
		}
		case "password_confirm": {
			if (element.value.length == 0) _err = empty_err;
			else if (element.form.elements['password'].value !== element.value) {
				_err = "Пароли должны совпадать.";
			}
			break;
		}
		case "login":
		case "email": {
			if (element.value.length == 0) _err = empty_err;
			else if (!element.value.match(/.+@.+\..+/)) _err = "Некорректный e-mail.";
			//else if (typeof num != 'undefined'); //checkUserEmail callback
			break;
		}
		default: {
		    var _element = jQuery(element),
		        val; 
				if(typeof $.inputmask == 'function'){
					val = (_element.hasClass('phone-valid')) ? _element.inputmask('unmaskedvalue') : element.value;
				} else {
					val = element.value;
				}
				
			if (val.length == 0) _err = empty_err;
			if(_element.hasClass('phone-valid') && !val.match(/^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$/)) _err = "Некорректный номер телефона.";
			if (element.name.match(/^.*e.*mail.*$/) && element.name != 'email_to' && element.name != 'system_email_to')
				if (!val.match(/.+@.+\..+/)) _err = "Некорректный e-mail.";
		}
	}
	return site.forms.errors.write(_err, element);
};

site.forms.errors.write = function (_err, element) {
	var parent = $(element).parents('.control-group');
		
	jQuery('div.help-inline', parent).remove();
	if (_err) {
		var err_block = document.createElement('div');
		err_block.className = "help-inline";
		err_block.innerHTML = _err;
		parent.addClass("error");
		parent.append(err_block);
		if (element.name == "password_confirm") element.value = "";
		element.focus();
		return false;
	}
	parent.removeClass("error");
	return true;
};

jQuery(document).ready(function(){site.forms.init()});