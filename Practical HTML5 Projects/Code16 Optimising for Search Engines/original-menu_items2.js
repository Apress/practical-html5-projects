BLANK_IMAGE = 'images/b.gif';

var STYLE = {
	border:2,			// item's border width, pixels; zero means "none"
	shadow:3,			// item's shadow size, pixels; zero means "none"
	color:{
		border:"#666666",	// color of the item border, if any
		shadow:"#DBD8D1",	// color of the item shadow, if any
		bgON:"white",		// background color for the items
		bgOVER:"#B6BDD2"	// background color for the item which is under mouse right now
	},
	css:{
		ON:"clsCMOn",		// CSS class for items
		OVER:"clsCMOver"	// CSS class  for item which is under mouse
	}
};

var MENU_ITEMS = [
	{pos:[370,250], itemoff:[0,99], leveloff:[21,0], style:STYLE, size:[22,100]},
	{code:"Page 1",
		sub:[
			{itemoff:[21,0]},
			{code:"SubPage 1",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			},
			{code:"SubPage 2",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			},
			{code:"SubPage 3",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			}
		]
	},
	{code:"Page 2",
		sub:[
			{itemoff:[21,0]},
			{code:"SubPage 1",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			},
			{code:"SubPage 2",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			},
			{code:"SubPage 3",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			}
		]
	},
	{code:"Page 3",
		sub:[
			{itemoff:[21,0]},
			{code:"SubPage 1",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			},
			{code:"SubPage 2",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			},
			{code:"SubPage 3",
				sub:[
					{leveloff:[0,99]},
					{code:"SubSubPage 1"},
					{code:"SubSubPage 2"},
					{code:"SubSubPage 3"}
				]
			}
		]
	}
];
