const Fs = require("fs");
const TerVals = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff];
const StyVals = {
	["b"]: "bold",
	["u"]: "underline",
	["r"]: "reverse",
	["i"]: "italic",
	["c"]: "undercurl",
	["s"]: "standout",
};


/**
 * HEX to RGB color format
 * @param {string} Hex
 */
const Hex2Rgb = function(Hex) {
	var Groups = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(Hex.toLowerCase());
	return Groups
		? { R: parseInt(Groups[1], 16),
			G: parseInt(Groups[2], 16),
			B: parseInt(Groups[3], 16) }
		: null;
}

/**
 * RGB to HEX color format
 * @param {number} R
 * @param {number} G
 * @param {number} B
 */
const Rgb2Hex = function(R, G, B) {
	var RGB = (R << 16) | (G << 8) | (B << 0);
	return "#" + (0x1000000 + RGB).toString(16).slice(1);
}

/**
 * RGB to x256 terminal color format
 * @param {number} R
 * @param {number} G
 * @param {number} B
 */
const Rgb2Ter = function(R, G, B) {
	var MR = Math.floor(R < 48 ? 0 : R < 115 ? 1 : (R - 35) / 40);
	var MG = Math.floor(G < 48 ? 0 : G < 115 ? 1 : (G - 35) / 40);
	var MB = Math.floor(B < 48 ? 0 : B < 115 ? 1 : (B - 35) / 40);

	var Avg = Math.floor((R + G + B) / 3);
	var GrI = Math.floor(Avg > 238 ? 23 : (Avg - 3) / 10);
	var CoI = 36 * MR + 6 * MG + 1 * MB;

	var CR = TerVals[MR];
	var CG = TerVals[MG];
	var CB = TerVals[MB];
	var GV = 8 + 10 * GrI;

	var CoE = (CR - R) ** 2 + (CG - G) ** 2 + (CB - B) ** 2;
	var GrE = (GV - R) ** 2 + (GV - G) ** 2 + (GV - B) ** 2;

	/*
	console.log("DEBUG INFO START");
	console.log(R, G, B);
	console.log(MR, MG, MB);
	console.log(CR, CG, CB);
	console.log(Avg, GV);
	console.log(GrI, CoI);
	console.log(GrE, CoE);
	console.log("DEBUG INFO END");
	*/

	return (CoE <= GrE)
		? 16 + CoI
		: 232 + GrI;
}


/**
 * Parses a color from formats: RGB, HEX, Palette
 * @param {any} Value
 * @param {Object} Palette?
 */
const GetColor = function(Value, Palette = null) {
	var R, G, B;

	if (Array.isArray(Value) && Value.length == 3)
		([R, G, B] = Value);

	else if (typeof Value == "string" && Value.startsWith("#"))
		({R, G, B} = Hex2Rgb(Value));

	else if (Palette != null && Palette[Value])
		({R, G, B} = GetColor(Palette[Value]));

	return {
		["R"]: R,
		["G"]: G,
		["B"]: B
	};
}

/**
 * Generates a color highlight in VimScript
 * @param {string} Type
 * @param {any} Color
 * @param {Object} Palette
 */
const GenHiCol = function(Type, Color, Palette) {
	if (Color == ".")
		return "";
	if (Type == "sp" && Color == null)
		return "";

	var GColor, TColor;
	if (Color != null && Color != "-") {
		var RGB = GetColor(Color, Palette);
		GColor = Rgb2Hex(RGB.R, RGB.G, RGB.B);
		TColor = Rgb2Ter(RGB.R, RGB.G, RGB.B);
	} else {
		GColor = "NONE";
		TColor = "NONE";
	}

	return `gui${Type}=${GColor}${Type == "sp" ? "" : ` cterm${Type}=${TColor}`}`;
}

/**
 * Generates a style highlight in VimScript
 * @param {string} Style
 */
const GenHiSty = function(Style) {
	if (Style == ".")
		return "";

	var BStyle;
	if (Style != null && Style != "-") {
		var Styles = [];
		for (var I = 0; I < Style.length; ++I)
			if (StyVals[Style.charAt(I)] != null)
				Styles.push(StyVals[Style.charAt(I)]);
		BStyle = Styles.join(",");
	} else {
		BStyle = "NONE";
	}

	return `gui=${BStyle} cterm=${BStyle}`;
}

/**
 * Generates the parameter array for a specific highlight
 * @param {string} Options
 * @param {Object} Palette
 */
const GenHi = function(Options, Palette) {
	var Params = [];
	var SplOpts = Options.split(" ");
	var FgColor = GenHiCol("fg", SplOpts[0], Palette);
	var BgColor = GenHiCol("bg", SplOpts[1], Palette);
	var Style   = GenHiSty(SplOpts[2]);
	var SpColor = GenHiCol("sp", SplOpts[3], Palette);

	if (FgColor != null)
		Params.push(FgColor);
	if (BgColor != null)
		Params.push(BgColor);
	if (Style != null)
		Params.push(Style);
	if (SpColor != null)
		Params.push(SpColor);

	return Params;
}


/**
 * Generates a VimScript colorscheme from a JSON configuration file
 * @param {string} File
 */
const Gen = function(File) {
	const Data     = JSON.parse(Fs.readFileSync(File, { encoding: "utf8" }));
	var Info       = Data["Information"] ?? {};
	var Palette    = Data["Palette"] ?? {};
	var HLGroups   = Data["Highlights"] ?? {};
	var HLLinks    = Data["Links"] ?? {};
	var TEColors   = Data["Terminal"] ?? [];

	var RFile = File.substr(0, File.length - 5);
	var Result = `" This file was generated with Nobody's Colorscheme Generator v1.0.0a
" File: ${RFile}.vim
" Maintainer: ${Info.Author ?? "Undefined"}
" Version: ${Info.Version ?? "1.0"}

set background=${Info.Background ?? "dark"}
highlight clear
if exists('syntax_on')
	syntax reset
endif
let g:colors_name='${Info.Name ?? RFile}'
\n`;

	for (const [HLGroup, Data] of Object.entries(HLGroups))
		Result += `highlight ${HLGroup} ${GenHi(Data, Palette).join(" ")}\n`;

	for (const [HLGroup, Link] of Object.entries(HLLinks))
		Result += `\nhighlight! link ${HLGroup} ${Link}`;

	TEColors = TEColors.map((Color) => {
		var RGB = GetColor(Color, Palette);
		return `'${Rgb2Hex(RGB.R, RGB.G, RGB.B)}'`;
	});

	if (TEColors.length == 16)
		Result += `${Result.endsWith("\n")?"":"\n"}\nlet g:terminal_ansi_colors = [ ${TEColors.join(", ")} ]`;

	Fs.writeFileSync(`colors/${RFile}.vim`, Result, { encoding: "utf8" });
	console.log(`Successfully generated 'colors/${RFile}.vim'`);
}


!Fs.existsSync("colors") && Fs.mkdirSync("colors");
Fs.readdirSync(".", { encoding: "utf8" }).forEach((F) => F.endsWith(".json") && Gen(F));
