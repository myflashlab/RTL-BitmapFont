## RTL-Bitmap Extension for Starling V2.3+ ##

Working with RTL in GPU world is frustrating but yet doable, if you spend enough time on it :D We are hoping that this project can give you an idea of how we managed to distinguish between different variants of every Arabic/Persian characters. If you find a better solution or if you can improve this library in anyway, we'd be happy to hear from you.

**Test the project**  
Open the demo intelliJ project available in this repository and run it. it's a desktop AIR project and as soon as it runs, you will see a bunch of RTL chars. As you can see, the words are correctly lined one after the other.

partially supported fonts:
* BKoodak
* Tahoma

Why do I say *partially*? I'm no Font expert but as far as I can see, some characters are not available in the final .png/.fnt files. My guess is that this is happening because I am using the [msdf-bmfont-xml](https://github.com/soimy/msdf-bmfont-xml) project to convert my RTL .ttf fonts to texture maps. I think this problem will be automatically solved if you create your textures using other software like the [Glyph Designer](https://www.71squared.com/glyphdesigner). But I can't say for sure because I haven't tested it. If you have tested this, please correct me here.

Why have I used *msdf-bmfont-xml*? I was adviced by [Daniel](https://twitter.com/PrimaryFeather) to do so. Starling 2.3+ supports Multi-Channel distance field textures, and *msdf-bmfont-xml* exports for that. The resulting texture is:

![Multi-Channel distance field texture](https://raw.githubusercontent.com/myflashlab/RTL-BitmapFont/master/AIR/src/assets/BKoodakBold.0.png) 

The awesome fact about distance field textures is that your texture size can be small but you can scale up your texts as much as you wish without loosing the quality. I just get super excited whenever I talk about this :laughing: **kudos to Daniel for bringing this to Starling.** if you want to learn more about this, please read the [Starling manual here](http://manual.starling-framework.org/en/#_msdf_bmfont_xml).

**The Logic**  
Persian & Arabic languages are very similar and of course they are both Right-to-Left. But their written form is super complicated. Let me compare it with English. In English we have the letter **b** and its capital form is **B**. The same letter in Persian/Arabic has 4 variants!
```
ﺑ When there's a letter after it
ﺒ When there's a letter before AND after it
ﺐ When there's a letter before it
ﺏ When it's used alone
```
So, the ```RTLUtil``` class checks the location and returns the corrected letter. something like this:
```actionscript
case 1576:  // ب
				
	switch (location2($text, $i))
	{
            case SEPARATE:
                charCode = 65167;
            break;
            case BEGINNING_STICKING:
                charCode = 65169;
            break;
            case MIDDLE_STICKING:
                charCode = 65170;
            break;
            case END_STICKING:
                charCode = 65168;
            break;
        }
break;
```
**Create the texture**  
Go to [msdf-bmfont-xml](https://github.com/soimy/msdf-bmfont-xml) and install the command-line tool they have. then run the following in **Terminal**:
```
msdf-bmfont -o Tahoma.png --charset-file charset.txt --texture-size 1024,1024 --smart-size Tahoma.ttf
```
Feel free to change the command parameters the way it suits you but I'll explain a few ones which are the most important ones. 

1. with ```-o Tahoma.png```, you are setting the output location of the texture. please note that the ```.fnt``` file will be generated too along with the texture.
2. ```charset.txt``` is a text file which you can put the font characters you wish to use inside the BitmapFont.
3. ```Tahoma.ttf``` is your RTL font.

**Add the RTL Starling extension**  
[Go here](https://github.com/myflashlab/RTL-BitmapFont/tree/master/AIR/src/starling/extensions/rtl_text) and copy the extension files and add them to your own project.

**Load your font in Starling**
Just like any normal Starling TextField instance, create one and show your RTL text.
```actionscript
[Embed(source="assets/Tahoma.fnt", mimeType="application/octet-stream")]
public static const TahomaXml:Class;

[Embed(source="assets/Tahoma.0.png")]
public static const TahomaTexture:Class;

var text:String = "آاببب اب با اپپپ اپ اتتت ات اثثث اث اججج اج اچچچ اچ اححح اح اخخخ اخ ادید اذیذ اریر ازیز اژیژ اسسس اس اششش اش اصصص اص اضضض اض اططط اط اظظظ اظ اععع اع اغغغ اغ اففف اف اققق اق اککک اک اگگگ اگ اللل ال اممم ام اننن ان اویو اههه اه اییی ای";
		
var texture:Texture = Texture.fromEmbeddedAsset(TahomaTexture);
var xml:XML = XML(new TahomaXml());
var bmpFontRTL:BitmapFontRTL = new BitmapFontRTL(texture, xml);
TextField.registerCompositor(bmpFontRTL, bmpFontRTL.name);

var textField:TextField = new TextField(stage.stageWidth * 0.9, stage.stageHeight * 0.9, text);
textField.setRequiresRecomposition();
textField.format.setTo("BKoodakBold", 30, Color.WHITE);
textField.format.horizontalAlign = Align.CENTER;
textField.format.verticalAlign = Align.CENTER;
textField.border = true;
textField.x = stage.stageWidth - textField.width >> 1;
textField.y = stage.stageHeight - textField.height >> 1;
textField.alpha = 0.5;
addChild(textField);
```
I really wish this was the last step but it's not :) it's time to get dirty! 

**Fix the offsets**  
Open the created .fnt file and start messing around with the ```xoffset``` attribute of the characters. You need to change them and then compile your project and see the results. I wish there where easier solution to this, but you need to do this for almost ALL of the characters to make sure they are correct in their positions. I have already done the **BKoodak** and **Tahoma** fonts for you to be able to see and get inspiered. 

I don't know who is responsible for this font-miss-location thing (is it the font itself? is it how font-to-texture programs work?) Anyway, if you ever created a new texture and fixed the letters for it, please feel free to share it with us :)

---------------------------------------
## Starling V1.x ##
We have an archive of the old project which works with Starling V1.x If you really need it, you can find [it here](https://github.com/myflashlab/RTL-BitmapFont/tree/master/starling1.x).