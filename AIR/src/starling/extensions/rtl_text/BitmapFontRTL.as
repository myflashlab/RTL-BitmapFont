// =================================================================================================
//
//	MyFLashLabs Team www.myflashlabs.com
//	Copyright 2018 All Rights Reserved.
//
//	Based on Starling Framework BitmapFont TextField
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.extensions.rtl_text
{
    import starling.text.BitmapChar;
    import starling.text.BitmapCharLocation;
    import starling.text.BitmapFont;
    import starling.text.TextFormat;
    import starling.text.TextOptions;
    import starling.textures.Texture;
    import starling.utils.Align;
    import starling.utils.StringUtil;

    /** The BitmapFont class parses bitmap font files and arranges the glyphs
     *  in the form of a text.
     *
     *  The class parses the XML format as it is used in the
     *  <a href="http://www.angelcode.com/products/bmfont/">AngelCode Bitmap Font Generator</a> or
     *  the <a href="http://glyphdesigner.71squared.com/">Glyph Designer</a>.
     *  This is what the file format looks like:
     *
     *  <pre>
     *  &lt;font&gt;
     *    &lt;info face="BranchingMouse" size="40" /&gt;
     *    &lt;common lineHeight="40" /&gt;
     *    &lt;pages&gt;  &lt;!-- currently, only one page is supported --&gt;
     *      &lt;page id="0" file="texture.png" /&gt;
     *    &lt;/pages&gt;
     *    &lt;chars&gt;
     *      &lt;char id="32" x="60" y="29" width="1" height="1" xoffset="0" yoffset="27" xadvance="8" /&gt;
     *      &lt;char id="33" x="155" y="144" width="9" height="21" xoffset="0" yoffset="6" xadvance="9" /&gt;
     *    &lt;/chars&gt;
     *    &lt;kernings&gt; &lt;!-- Kerning is optional --&gt;
     *      &lt;kerning first="83" second="83" amount="-4"/&gt;
     *    &lt;/kernings&gt;
     *  &lt;/font&gt;
     *  </pre>
     *
     *  Pass an instance of this class to the method <code>registerBitmapFont</code> of the
     *  TextField class. Then, set the <code>fontName</code> property of the text field to the
     *  <code>name</code> value of the bitmap font. This will make the text field use the bitmap
     *  font.
     */
    public class BitmapFontRTL extends BitmapFont
    {
		private var _rightToLeft:Boolean = true;

        // helper objects
        private static var sLines:Array = [];
        private static var sDefaultOptions:TextOptions = new TextOptions();

        private static const CHAR_MISSING:int         =  0;
        private static const CHAR_TAB:int             =  9;
        private static const CHAR_NEWLINE:int         = 10;
        private static const CHAR_CARRIAGE_RETURN:int = 13;
        private static const CHAR_SPACE:int           = 32;

        /** Creates a bitmap font by parsing an XML file and uses the specified texture.
         *  If you don't pass any data, the "mini" font will be created. */
        public function BitmapFontRTL(texture:Texture=null, fontData:*=null)/**/
        {
            super(texture, fontData);
        }

        override public function arrangeChars(width:Number, height:Number, text:String,
                                              format:TextFormat, options:TextOptions):Vector.<BitmapCharLocation>
        {
            if (!_rightToLeft) return super.arrangeChars(width, height, text, format, options);
            if (text == null || text.length == 0) return BitmapCharLocation.vectorFromPool();
            if (options == null) options = sDefaultOptions;

            text = RTLUtil.changeNumber(text);
            var charCodes:Array = RTLUtil.charCode(text);

            var kerning:Boolean = format.kerning;
            var leading:Number = format.leading;
            var hAlign:String = format.horizontalAlign;
            var vAlign:String = format.verticalAlign;
            var fontSize:Number = format.size;
            var autoScale:Boolean = options.autoScale;
            var wordWrap:Boolean = options.wordWrap;
            var nativeSize:Number = this.size;
            var nativeLineHeight:Number = this.lineHeight;
            var padding:Number = this.padding;

            var finished:Boolean = false;
            var charLocation:BitmapCharLocation;
            var numChars:int;
            var containerWidth:Number;
            var containerHeight:Number;
            var scale:Number;
            var i:int, j:int;

            if (fontSize < 0) fontSize *= -nativeSize;

            while (!finished)
            {
                sLines.length = 0;
                scale = fontSize / nativeSize;
                containerWidth  = (width  - 2 * padding) / scale;
                containerHeight = (height - 2 * padding) / scale;

                if (nativeSize <= containerHeight)
                {
                    var lastWhiteSpace:int = -1;
                    var lastCharID:int = -1;
                    var currentX:Number = containerWidth;
                    var currentY:Number = 0;
                    var currentLine:Vector.<BitmapCharLocation> = BitmapCharLocation.vectorFromPool();

                    numChars = charCodes.length;
                    for (i=0; i<numChars; ++i)
                    {
                        var lineFull:Boolean = false;
                        var charID:int = charCodes[i];
                        var char:BitmapChar = getChar(charID);

                        if (charID == CHAR_NEWLINE || charID == CHAR_CARRIAGE_RETURN)
                        {
                            lineFull = true;
                        }
                        else
                        {
                            if (char == null)
                            {
                                trace(StringUtil.format(
                                    "[Starling] Character '{0}' (id: {1}) not found in '{2}'",
                                    text.charAt(i), charID, name));

                                charID = CHAR_MISSING;
                                char = getChar(CHAR_MISSING);
                            }

                            if (charID == CHAR_SPACE || charID == CHAR_TAB)
                                lastWhiteSpace = i;

                            if (kerning)
                                currentX -= char.getKerning(charID) + char.xOffset + char.xAdvance;

                            charLocation = BitmapCharLocation.instanceFromPool(char);
                            charLocation.index = i;
                            charLocation.x = currentX;
                            charLocation.y = currentY + char.yOffset;
                            currentLine[currentLine.length] = charLocation; // push

                            // currentX += char.xAdvance + spacing;
                            lastCharID = charID;

                            if (charLocation.x < 0)
                            {
                                if (wordWrap)
                                {
                                    // when autoscaling, we must not split a word in half -> restart
                                    if (autoScale && lastWhiteSpace == -1)
                                        break;

                                    // remove characters and add them again to next line
                                    var numCharsToRemove:int = lastWhiteSpace == -1 ? 1 : i - lastWhiteSpace;

                                    for (j=0; j<numCharsToRemove; ++j) // faster than 'splice'
                                        currentLine.pop();

                                    if (currentLine.length == 0)
                                        break;

                                    i -= numCharsToRemove;
                                }
                                else
                                {
                                    if (autoScale) break;
                                    currentLine.pop();

                                    // continue with next line, if there is one
                                    while (i < numChars - 1 && text.charCodeAt(i) != CHAR_NEWLINE)
                                        ++i;
                                }

                                lineFull = true;
                            }
                        }

                        if (i == numChars - 1)
                        {
                            sLines[sLines.length] = currentLine; // push
                            finished = true;
                        }
                        else if (lineFull)
                        {
                            sLines[sLines.length] = currentLine; // push

                            if (lastWhiteSpace == i)
                                currentLine.pop();

                            if (currentY + nativeLineHeight + leading + nativeSize <= containerHeight)
                            {
                                currentLine = BitmapCharLocation.vectorFromPool();
                                currentX = containerWidth;
                                currentY += nativeLineHeight + leading;
                                lastWhiteSpace = -1;
                                lastCharID = -1;
                            }
                            else
                            {
                                break;
                            }
                        }
                    } // for each char
                } // if (_lineHeight <= containerHeight)

                if (autoScale && !finished && fontSize > 3)
                    fontSize -= 1;
                else
                    finished = true;
            } // while (!finished)

            var finalLocations:Vector.<BitmapCharLocation> = BitmapCharLocation.vectorFromPool();
            var numLines:int = sLines.length;
            var bottom:Number = currentY + nativeLineHeight;
            var yOffset:int = 0;

            if (vAlign == Align.BOTTOM)      yOffset =  containerHeight - bottom;
            else if (vAlign == Align.CENTER) yOffset = (containerHeight - bottom) / 2;

            for (var lineID:int=0; lineID<numLines; ++lineID)
            {
                var line:Vector.<BitmapCharLocation> = sLines[lineID];
                numChars = line.length;

                if (numChars == 0) continue;

                var xOffset:int = 0;
                var lastLocation:BitmapCharLocation = line[line.length-1];
                var right:Number = lastLocation.x;

                if (hAlign == Align.LEFT)        xOffset = right;
                else if (hAlign == Align.CENTER) xOffset = right / 2;

                for (var c:int=0; c<numChars; ++c)
                {
                    charLocation = line[c];
                    charLocation.x = scale * (charLocation.x - xOffset) + padding;
                    charLocation.y = scale * (charLocation.y + yOffset + offsetY) + padding;
                    charLocation.scale = scale;

                    if (charLocation.char.width > 0 && charLocation.char.height > 0)
                        finalLocations[finalLocations.length] = charLocation;
                }
            }

            return finalLocations;
        }

        public function get rightToLeft():Boolean { return _rightToLeft; }
        public function set rightToLeft(value:Boolean):void { _rightToLeft = value; }
    }
}
