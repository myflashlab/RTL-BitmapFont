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
    /**
	 * ...
	 * @author majid - Hadi
	 */
	public class RTLUtil
	{
		public static const BEGINNING_STICKING:String = "beginningSticking";
		public static const MIDDLE_STICKING:String = "middleSticking";
		public static const END_STICKING:String = "endSticking";
		public static const SEPARATE:String = "separate";
		
		public function RTLUtil():void
		{
		}
		
		public static function charCode($text:String):Array
		{
			var charCodeArr:Array = [];
			
			var $i:int;
			var lng:int = $text.length;
			
			for ($i = 0; $i < lng; $i++)
			{
				var charCode:int = -1;
				//trace("$text.charCodeAt($i): ", $text.charCodeAt($i));
				switch ($text.charCodeAt($i))
				{
					case 32:	// space
						
						charCode = 32;
						
					break;
					case 34:	// "
						
						charCode = 34;
						
					break;
					case 33:	// !
						
						charCode = 33;
						
					break;
					case 35:	// #
						
						charCode = 35;
						
					break;
					case 36:	// $
						
						charCode = 36;
						
					break;
					case 37:	// %
						
						charCode = 37;
						
					break;
					case 38:	// &
						
						charCode = 38;
						
					break;
					case 40:	// (
						
						charCode = 41;
						
					break;
					case 41:	// )
						
						charCode = 40;
						
					break;
					case 42:	// *
						
						charCode = 215;
						
					break;
					case 43:	// +
						
						charCode = 43;
						
					break;
					case 44:	// ,
						
						charCode = 44;
						
					break;
					case 46:	// .
						
						charCode = 46;
						
					break;
					case 47:	// /
						
						charCode = 47;
						
					break;
					case 48:	// 0
						
						charCode = 1632;
						
					break;
					case 49:	// 1
						
						charCode = 1633;
						
					break;
					case 50:	// 2
						
						charCode = 1634;
						
					break;
					case 51:	// 3
						
						charCode = 1635;
						
					break;
					case 52:	// 4
						
						charCode = 1636;
						
					break;
					case 53:	// 5
						
						charCode = 1637;
						
					break;
					case 54:	// 6
						
						charCode = 1638;
						
					break;
					case 55:	// 7
						
						charCode = 1639;
						
					break;
					case 56:	// 8
						
						charCode = 1640;
						
					break;
					case 57:	// 9
						
						charCode = 1641;
						
					break;
					case 58:	// :
						
						charCode = 58;
						
					break;
					case 59:	// ;
						
						charCode = 59;
						
					break;
					case 60:	// <
						
						charCode = 60;
						
					break;
					case 61:	// =
						
						charCode = 61;
						
					break;
					case 62:	// >
						
						charCode = 62;
						
					break;
					case 63:	// ?
						
						charCode = 63;
						
					break;
					case 64:	// @
						
						charCode = 64;
						
					break;
					case 91:	// [
						
						charCode = 93;
						
					break;
					case 92:	// \
						
						charCode = 92;
						
					break;
					case 93:	// ]
						
						charCode = 91;
						
					break;
					case 94:	// ^
						
						charCode = 94;
						
					break;
					case 95:	// _
						
						charCode = 95;
						
					break;
					case 96:	// '
						
						charCode = 96;
						
					break;
					case 123:	// {
						
						charCode = 125;
						
					break;
					case 124:	// |
						
						charCode = 124;
						
					break;
					case 125:	// }
						
						charCode = 123;
						
					break;
					case 171:	// «
						
						charCode = 187;
						
					break;
					case 187:	// »
						
						charCode = 171;
						
					break;
					case 215:	// ×
						
						charCode = 215;
						
					break;
					case 247:	// ÷
						
						charCode = 247;
						
					break;
					case 1546:	// ،
						
						charCode = 1546;
						
					break;
					case 1563:	// ؛
						
						charCode = 1563;
						
					break;
					case 1567:	// ؟
						
						charCode = 1567;
						
					break;
					case 1569:	// ء
						
						charCode = 65152;
						
					break;
					case 1600:	// -
						
						charCode = 1600;
						
					break;
					case 1570:	// آ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65153;
							break;
							case END_STICKING:
								charCode = 65154;
							break;
							default:
								charCode = 65153;
						}
						
					break;
					case 1571:	// أ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65155;
							break;
							case END_STICKING:
								charCode = 65156;
							break;
							default:
								charCode = 65155;
						}
						
					break;
					case 1572:	// ؤ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65157;
							break;
							case END_STICKING:
								charCode = 65158;
							break;
							default:
								charCode = 65157;
						}
						
					break;
					case 1573:	// إ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65159;
							break;
							case END_STICKING:
								charCode = 65160;
							break;
							default:
								charCode = 65159;
						}
						
					break;
					case 1574:	// ئ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65161;
							break;
							case BEGINNING_STICKING:
								charCode = 65163;
							break;
							case MIDDLE_STICKING:
								charCode = 65164;
							break;
							case END_STICKING:
								charCode = 65162;
							break;
							default:
						}
						
					break;
					case 1575:	// ا
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65165;
							break;
							case END_STICKING:
								charCode = 65166;
							break;
							default:
								charCode = 65165;
						}
						
					break;
					case 1576:	// ب
						
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
							default:
						}
						
					break;
					case 1577:	// ت گرد
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65171;
							break;
							case END_STICKING:
								charCode = 65172;
							break;
							default:
								charCode = 65171;
						}
						
					break;
					case 1578:	// ت
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65173;
							break;
							case BEGINNING_STICKING:
								charCode = 65175;
							break;
							case MIDDLE_STICKING:
								charCode = 65176;
							break;
							case END_STICKING:
								charCode = 65174;
							break;
							default:
						}
						
					break;
					case 1579:	// ث
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65177;
							break;
							case BEGINNING_STICKING:
								charCode = 65179;
							break;
							case MIDDLE_STICKING:
								charCode = 65180;
							break;
							case END_STICKING:
								charCode = 65178;
							break;
							default:
						}
						
					break;
					case 1580:		// ج
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65181;
							break;
							case BEGINNING_STICKING:
								charCode = 65183;
							break;
							case MIDDLE_STICKING:
								charCode = 65184;
							break;
							case END_STICKING:
								charCode = 65182;
							break;
							default:
						}
						
					break;
					case 1581:		// ح
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65185;
							break;
							case BEGINNING_STICKING:
								charCode = 65187;
							break;
							case MIDDLE_STICKING:
								charCode = 65188;
							break;
							case END_STICKING:
								charCode = 65186;
							break;
							default:
						}
						
					break;
					case 1582:		// خ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65189;
							break;
							case BEGINNING_STICKING:
								charCode = 65191;
							break;
							case MIDDLE_STICKING:
								charCode = 65192;
							break;
							case END_STICKING:
								charCode = 65190;
							break;
							default:
						}
						
					break;
					case 1583:	// د
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65193;
							break;
							case END_STICKING:
								charCode = 65194;
							break;
							default:
								charCode = 65193;
						}
						
					break;
					case 1584:	// ذ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65195;
							break;
							case END_STICKING:
								charCode = 65196;
							break;
							default:
								charCode = 65195;
						}
						
					break;
					case 1585:	// ر
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65197;
							break;
							case END_STICKING:
								charCode = 65198;
							break;
							default:
								charCode = 65197;
						}
						
					break;
					case 1586:	// ز
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65199;
							break;
							case END_STICKING:
								charCode = 65200;
							break;
							default:
								charCode = 65199;
						}
						
					break;
					case 1587:		// س
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65201;
							break;
							case BEGINNING_STICKING:
								charCode = 65203;
							break;
							case MIDDLE_STICKING:
								charCode = 65204;
							break;
							case END_STICKING:
								charCode = 65202;
							break;
							default:
						}
						
					break;
					case 1588:		// ش
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65205;
							break;
							case BEGINNING_STICKING:
								charCode = 65207;
							break;
							case MIDDLE_STICKING:
								charCode = 65208;
							break;
							case END_STICKING:
								charCode = 65206;
							break;
							default:
						}
						
					break;
					case 1589:		// ص
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65209;
							break;
							case BEGINNING_STICKING:
								charCode = 65211;
							break;
							case MIDDLE_STICKING:
								charCode = 65212;
							break;
							case END_STICKING:
								charCode = 65210;
							break;
							default:
						}
						
					break;
					case 1590:		// ض
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65213;
							break;
							case BEGINNING_STICKING:
								charCode = 65215;
							break;
							case MIDDLE_STICKING:
								charCode = 65216;
							break;
							case END_STICKING:
								charCode = 65214;
							break;
							default:
						}
						
					break;
					case 1591:		// ط
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65217;
							break;
							case BEGINNING_STICKING:
								charCode = 65219;
							break;
							case MIDDLE_STICKING:
								charCode = 65220;
							break;
							case END_STICKING:
								charCode = 65218;
							break;
							default:
						}
						
					break;
					case 1592:		// ظ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65221;
							break;
							case BEGINNING_STICKING:
								charCode = 65223;
							break;
							case MIDDLE_STICKING:
								charCode = 65224;
							break;
							case END_STICKING:
								charCode = 65222;
							break;
							default:
						}
						
					break;
					case 1593:		// ع
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65225;
							break;
							case BEGINNING_STICKING:
								charCode = 65227;
							break;
							case MIDDLE_STICKING:
								charCode = 65228;
							break;
							case END_STICKING:
								charCode = 65226;
							break;
							default:
						}
						
					break;
					case 1594:		// غ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65229;
							break;
							case BEGINNING_STICKING:
								charCode = 65231;
							break;
							case MIDDLE_STICKING:
								charCode = 65232;
							break;
							case END_STICKING:
								charCode = 65230;
							break;
							default:
						}
						
					break;
					case 1601:		// ف
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65233;
							break;
							case BEGINNING_STICKING:
								charCode = 65235;
							break;
							case MIDDLE_STICKING:
								charCode = 65236;
							break;
							case END_STICKING:
								charCode = 65234;
							break;
							default:
						}
						
					break;
					case 1602:		// ق
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65237;
							break;
							case BEGINNING_STICKING:
								charCode = 65239;
							break;
							case MIDDLE_STICKING:
								charCode = 65240;
							break;
							case END_STICKING:
								charCode = 65238;
							break;
							default:
						}
						
					break;
					case 1603:		// ک
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64398;
							break;
							case BEGINNING_STICKING:
								charCode = 64400;
							break;
							case MIDDLE_STICKING:
								charCode = 64401;
							break;
							case END_STICKING:
								charCode = 64399;
							break;
							default:
						}
						
					break;
					case 1604:		// ل
						
						if ($i < ($text.length - 1))
						{
							if ($text.charCodeAt($i + 1) == 1575)
							{
								if ($i == ($text.length - 2))
								{
									if ($text.charCodeAt($i + 1) == 1575)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65275;
											break;
											case END_STICKING:
												charCode = 65276;
											break;
											default:
										}
										
										$i += 1;
									}
									else 
									{
										switch (location2($text, $i))
										{
											case SEPARATE:
												charCode = 65245;
											break;
											case BEGINNING_STICKING:
												charCode = 65247;
											break;
											case MIDDLE_STICKING:
												charCode = 65248;
											break;
											case END_STICKING:
												charCode = 65246;
											break;
											default:
										}
									}
								}
								else if ($i == ($text.length - 3))
								{
									if ($text.charCodeAt($i + 1) == 1575 && $text.charCodeAt($i + 2) == 1569)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65271;
											break;
											case END_STICKING:
												charCode = 65272;
											break;
											default:
										}
										
										$i += 2;
									}
									else if ($text.charCodeAt($i + 1) == 1575)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65275;
											break;
											case END_STICKING:
												charCode = 65276;
											break;
											default:
										}
										
										$i += 1;
									}
								}
								else if ($i == ($text.length - 4))
								{
									if ($text.charCodeAt($i + 1) == 1575 && $text.charCodeAt($i + 2) == 1618 && $text.charCodeAt($i + 3) == 1569)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65271;
											break;
											case END_STICKING:
												charCode = 65272;
											break;
											default:
										}
										
										$i += 3;
									}
									else if ($text.charCodeAt($i + 1) == 1575)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65275;
											break;
											case END_STICKING:
												charCode = 65276;
											break;
											default:
										}
										
										$i += 1;
									}
								}
								else
								{
									if ($text.charCodeAt($i + 1) == 1575 && $text.charCodeAt($i + 2) == 1618 && $text.charCodeAt($i + 3) == 1569)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65271;
											break;
											case END_STICKING:
												charCode = 65272;
											break;
											default:
										}
										
										$i += 3;
									}
									else if ($text.charCodeAt($i + 1) == 1575)
									{
										switch (location1($text, $i))
										{
											case SEPARATE:
												charCode = 65275;
											break;
											case END_STICKING:
												charCode = 65276;
											break;
											default:
										}
										
										$i += 1;
									}
								}
							}
							else if ($i <= (lng - 3) && $text.charCodeAt($i + 1) == 1618 && $text.charCodeAt($i + 2) == 1571)
							{
								switch (location1($text, $i))
								{
									case SEPARATE:
										charCode = 65271;
									break;
									case END_STICKING:
										charCode = 65272;
									break;
									default:
								}
								
								$i += 2;
							}
							else if ($text.charCodeAt($i + 1) == 1570)
							{
								switch (location1($text, $i))
								{
									case SEPARATE:
										charCode = 65269;
									break;
									case END_STICKING:
										charCode = 65270;
									break;
									default:
								}
								
								$i += 1;
							}
							else if ($text.charCodeAt($i + 1) == 1573)
							{
								switch (location1($text, $i))
								{
									case SEPARATE:
										charCode = 65273;
									break;
									case END_STICKING:
										charCode = 65274;
									break;
									default:
								}
								
								$i += 1;
							}
							else 
							{
								switch (location2($text, $i))
								{
									case SEPARATE:
										charCode = 65245;
									break;
									case BEGINNING_STICKING:
										charCode = 65247;
									break;
									case MIDDLE_STICKING:
										charCode = 65248;
									break;
									case END_STICKING:
										charCode = 65246;
									break;
									default:
								}
							}
						}
						else
						{
							switch (location2($text, $i))
							{
								case SEPARATE:
									charCode = 65245;
								break;
								case BEGINNING_STICKING:
									charCode = 65247;
								break;
								case MIDDLE_STICKING:
									charCode = 65248;
								break;
								case END_STICKING:
									charCode = 65246;
								break;
								default:
							}
						}
						
					break;
					case 1605:		// م
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65249;
							break;
							case BEGINNING_STICKING:
								charCode = 65251;
							break;
							case MIDDLE_STICKING:
								charCode = 65252;
							break;
							case END_STICKING:
								charCode = 65250;
							break;
							default:
						}
						
					break;
					case 1606:		// ن
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65253;
							break;
							case BEGINNING_STICKING:
								charCode = 65255;
							break;
							case MIDDLE_STICKING:
								charCode = 65256;
							break;
							case END_STICKING:
								charCode = 65254;
							break;
							default:
						}
						
					break;
					case 1607:		// ه
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65257;
							break;
							case BEGINNING_STICKING:
								charCode = 65259;
							break;
							case MIDDLE_STICKING:
								charCode = 65260;
							break;
							case END_STICKING:
								charCode = 65258;
							break;
							default:
						}
						
					break;
					case 1608:	// و
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 65261;
							break;
							case END_STICKING:
								charCode = 65262;
							break;
							default:
								charCode = 65261;
						}
						
					break;
					case 1609:		// ی
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64508;
							break;
							case BEGINNING_STICKING:
								charCode = 64510;
							break;
							case MIDDLE_STICKING:
								charCode = 64511;
							break;
							case END_STICKING:
								charCode = 64509;
							break;
							default:
						}
						
					break;
					case 1610:		// ی
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 65265;
							break;
							case BEGINNING_STICKING:
								charCode = 64510;
							break;
							case MIDDLE_STICKING:
								charCode = 64511;
							break;
							case END_STICKING:
								charCode = 65266;
							break;
							default:
						}
						
					break;
					case 1611:		//an
						
						charCode = 1611;
						
					break;
					case 1612:		//on
						
						charCode = 1612;
						
					break;
					case 1613:		//en
						
						charCode = 1613;
						
					break;
					case 1614:		//A
						
						charCode = 1614;
						
					break;
					case 1615:		//O
						
						charCode = 1615;
						
					break;
					case 1616:		//E
						
						charCode = 1616;
						
					break;
					case 1617:		// 
						
						if ($i < ($text.length - 1))
						{
							if ($text.charCodeAt($i + 1) == 1611)
							{
								charCode = 1000001;
								$i ++;
							}
							else if ($text.charCodeAt($i + 1) == 1612)
							{
								charCode = 1000002;
								$i ++;
							}
							else if ($text.charCodeAt($i + 1) == 1613)
							{
								charCode = 1000003;
								$i ++;
							}
							else if ($text.charCodeAt($i + 1) == 1614)
							{
								charCode = 1000004;
								$i ++;
							}
							else if ($text.charCodeAt($i + 1) == 1615)
							{
								charCode = 1000005;
								$i ++;
							}
							else if ($text.charCodeAt($i + 1) == 1616)
							{
								charCode = 1000006;
								$i ++;
							}
							else
							{
								charCode = 1617;
							}
						}
						else
						{
							charCode = 1617;
						}
						
					break;
					case 1618:		//Sokon
						
						charCode = 1618;
						
					break;
					case 1662:	// پ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64342;
							break;
							case BEGINNING_STICKING:
								charCode = 64344;
							break;
							case MIDDLE_STICKING:
								charCode = 64345;
							break;
							case END_STICKING:
								charCode = 64343;
							break;
							default:
						}
						
					break;
					case 1670:		// چ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64378;
							break;
							case BEGINNING_STICKING:
								charCode = 64380;
							break;
							case MIDDLE_STICKING:
								charCode = 64381;
							break;
							case END_STICKING:
								charCode = 64379;
							break;
							default:
						}
						
					break;
					case 1688:	// ژ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 64394;
							break;
							case END_STICKING:
								charCode = 64395;
							break;
							default:
								charCode = 64394;
						}
						
					break;
					case 1705:		// ک
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64398;
							break;
							case BEGINNING_STICKING:
								charCode = 64400;
							break;
							case MIDDLE_STICKING:
								charCode = 64401;
							break;
							case END_STICKING:
								charCode = 64399;
							break;
							default:
						}
						
					break;
					case 1711:		// گ
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64402;
							break;
							case BEGINNING_STICKING:
								charCode = 64404;
							break;
							case MIDDLE_STICKING:
								charCode = 64405;
							break;
							case END_STICKING:
								charCode = 64403;
							break;
							default:
						}
						
					break;
					case 1728:	// هئ
						
						switch (location1($text, $i))
						{
							case SEPARATE:
								charCode = 64420;
							break;
							case END_STICKING:
								charCode = 64421;
							break;
							default:
								charCode = 64420;
						}
						
					break;
					case 1740:		// ی
						
						switch (location2($text, $i))
						{
							case SEPARATE:
								charCode = 64508;
							break;
							case BEGINNING_STICKING:
								charCode = 64510;
							break;
							case MIDDLE_STICKING:
								charCode = 64511;
							break;
							case END_STICKING:
								charCode = 64509;
							break;
							default:
						}
						
					break;
					case 8207:		
						
						charCode = -1;
						
					break;
					default:
						charCode = $text.charCodeAt($i);
				}
				
				//trace(charCode, " : ", $text.charAt($i));
				
				if (charCode != -1) charCodeArr.push(charCode);
			}
			
			return charCodeArr;
		}
		
		private static function location1($text:String, $i:int):String
		{
			var loc:String = SEPARATE;
			var preSticking:int = -1;
			
			var preNotStickArr:Array = [32, 33, 37, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 61, 91, 93, 123, 125, 171, 183, 187, 215, 247, 729, 1548, 1563, 1567, 1569, 1570, 1571, 1572, 1573, 1575, 1577, 1583, 1584, 1585, 1586, 1600, 1608, 1632, 1633, 1634, 1635, 1636, 1637, 1638, 1639, 1640, 1641, 1688, 1728, 1776, 1777, 1778, 1779, 1780, 1781, 1782, 1783, 1784, 1785, 8216, 8217, 8220, 8221, 8249, 8250, 8729, 64394, 64395, 64420, 64421, 65010, 65153, 65154, 65155, 65156, 65157, 65158, 65159, 65160, 65161, 65162, 65165, 65166, 65171, 65172, 65193, 65194, 65195, 65196, 65197, 65198, 65199, 65200, 65261, 65262, 65269, 65270, 65271, 65272, 65273, 65274, 65275, 65276];
			var preStickArr:Array = [1574, 1576, 1578, 1579, 1580, 1581, 1582, 1587, 1588, 1589, 1590, 1591, 1592, 1593, 1594, 1600, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1609, 1610, 1662, 1670, 1705, 1711, 1740, 64342, 64343, 64344, 64345, 64378, 64379, 64380, 64381, 64398, 64399, 64400, 64401, 64402, 64403, 64404, 64405, 64508, 64509, 64510, 64511, 65163, 65164, 65167, 65168, 65169, 65170, 65173, 65174, 65175, 65176, 65177, 65178, 65179, 65180, 65181, 65182, 65183, 65184, 65185, 65186, 65187, 65188, 65189, 65190, 65191, 65192, 65201, 65202, 65203, 65204, 65205, 65206, 65207, 65208, 65209, 65210, 65211, 65212, 65213, 65214, 65215, 65216, 65217, 65218, 65219, 65220, 65221, 65222, 65223, 65224, 65225, 65226, 65227, 65228, 65229, 65230, 65231, 65232, 65233, 65234, 65235, 65236, 65237, 65238, 65239, 65240, 65241, 65242, 65243, 65244, 65245, 65246, 65247, 65248, 65249, 65250, 65251, 65252, 65253, 65254, 65255, 65256, 65257, 65258, 65259, 65260, 65263, 65264, 65265, 65266, 65267, 65268];
			
			var preChar1:int = -1;
			var preChar2:int = -1;
			var preChar3:int = -1;
			var preChar4:int = -1;
			var i:int = 0;
			var lng:int = 0;
			
			if ($i == 0) preSticking = 0;
			else if ($i == 1)
			{
				preChar1 = $text.charCodeAt($i - 1);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
			}
			else if ($i == 2)
			{
				preChar1 = $text.charCodeAt($i - 1);
				preChar2 = $text.charCodeAt($i - 2);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
				
				if (preSticking == -1)
				{
					lng = preNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (preChar1 == preNotStickArr[i])
						{
							preSticking = 0;
							break;
						}
					}
					
					if (preSticking == -1)
					{
						lng = preStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (preChar2 == preStickArr[i])
							{
								preSticking = 1;
								break;
							}
						}
					}
				}
			}
			else if ($i == 3)
			{
				preChar1 = $text.charCodeAt($i - 1);
				preChar2 = $text.charCodeAt($i - 2);
				preChar3 = $text.charCodeAt($i - 3);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
				
				if (preSticking == -1)
				{
					lng = preNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (preChar1 == preNotStickArr[i])
						{
							preSticking = 0;
							break;
						}
					}
					
					if (preSticking == -1)
					{
						lng = preStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (preChar2 == preStickArr[i])
							{
								preSticking = 1;
								break;
							}
						}
						
						if (preSticking == -1)
						{
							lng = preNotStickArr.length;
							
							for (i = 0; i < lng; i++) 
							{
								if (preChar2 == preNotStickArr[i])
								{
									preSticking = 0;
									break;
								}
							}
							
							if (preSticking == -1)
							{
								lng = preStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (preChar3 == preStickArr[i])
									{
										preSticking = 1;
										break;
									}
								}
							}
						}
					}
				}
			}
			else if ($i > 3)
			{
				preChar1 = $text.charCodeAt($i - 1);
				preChar2 = $text.charCodeAt($i - 2);
				preChar3 = $text.charCodeAt($i - 3);
				preChar4 = $text.charCodeAt($i - 4);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
				
				if (preSticking == -1)
				{
					lng = preNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (preChar1 == preNotStickArr[i])
						{
							preSticking = 0;
							break;
						}
					}
					
					if (preSticking == -1)
					{
						lng = preStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (preChar2 == preStickArr[i])
							{
								preSticking = 1;
								break;
							}
						}
						
						if (preSticking == -1)
						{
							lng = preNotStickArr.length;
							
							for (i = 0; i < lng; i++) 
							{
								if (preChar2 == preNotStickArr[i])
								{
									preSticking = 0;
									break;
								}
							}
							
							if (preSticking == -1)
							{
								lng = preStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (preChar3 == preStickArr[i])
									{
										preSticking = 1;
										break;
									}
								}
							}
							
							if (preSticking == -1)
							{
								lng = preNotStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (preChar3 == preNotStickArr[i])
									{
										preSticking = 0;
										break;
									}
								}
								
								if (preSticking == -1)
								{
									lng = preStickArr.length;
									
									for (i = 0; i < lng; i++) 
									{
										if (preChar4 == preStickArr[i])
										{
											preSticking = 1;
											break;
										}
									}
								}
							}
						}
					}
				}
			}
			
			
			if (preSticking == 1) loc = END_STICKING;
			else loc = SEPARATE;
			
			return loc;
		}
		
		private static function location2($text:String, $i:int):String
		{
			var loc:String = SEPARATE;
			var preSticking:int = -1;
			var nextSticking:int = -1;
			
			var preNotStickArr:Array = [32, 33, 37, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 61, 91, 93, 123, 125, 171, 183, 187, 215, 247, 729, 1548, 1563, 1567, 1569, 1570, 1571, 1572, 1573, 1575, 1577, 1583, 1584, 1585, 1586, 1600, 1608, 1632, 1633, 1634, 1635, 1636, 1637, 1638, 1639, 1640, 1641, 1688, 1728, 1776, 1777, 1778, 1779, 1780, 1781, 1782, 1783, 1784, 1785, 8216, 8217, 8220, 8221, 8249, 8250, 8729, 64394, 64395, 64420, 64421, 65010, 65153, 65154, 65155, 65156, 65157, 65158, 65159, 65160, 65161, 65162, 65165, 65166, 65171, 65172, 65193, 65194, 65195, 65196, 65197, 65198, 65199, 65200, 65261, 65262, 65269, 65270, 65271, 65272, 65273, 65274, 65275, 65276];
			var preStickArr:Array = [1574, 1576, 1578, 1579, 1580, 1581, 1582, 1587, 1588, 1589, 1590, 1591, 1592, 1593, 1594, 1600, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1609, 1610, 1662, 1670, 1705, 1711, 1740, 64342, 64343, 64344, 64345, 64378, 64379, 64380, 64381, 64398, 64399, 64400, 64401, 64402, 64403, 64404, 64405, 64508, 64509, 64510, 64511, 65163, 65164, 65167, 65168, 65169, 65170, 65173, 65174, 65175, 65176, 65177, 65178, 65179, 65180, 65181, 65182, 65183, 65184, 65185, 65186, 65187, 65188, 65189, 65190, 65191, 65192, 65201, 65202, 65203, 65204, 65205, 65206, 65207, 65208, 65209, 65210, 65211, 65212, 65213, 65214, 65215, 65216, 65217, 65218, 65219, 65220, 65221, 65222, 65223, 65224, 65225, 65226, 65227, 65228, 65229, 65230, 65231, 65232, 65233, 65234, 65235, 65236, 65237, 65238, 65239, 65240, 65241, 65242, 65243, 65244, 65245, 65246, 65247, 65248, 65249, 65250, 65251, 65252, 65253, 65254, 65255, 65256, 65257, 65258, 65259, 65260, 65263, 65264, 65265, 65266, 65267, 65268];
			
			var pastNotStickArr:Array = [32, 33, 37, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 61, 91, 93, 123, 125, 171, 183, 187, 215, 247, 729, 1548, 1563, 1567, 1569, 1600, 1632, 1633, 1634, 1635, 1636, 1637, 1638, 1639, 1640, 1641, 1776, 1777, 1778, 1779, 1780, 1781, 1782, 1783, 1784, 1785, 8216, 8217, 8220, 8221, 8249, 8250, 8729, 65010];
			var pastStickArr:Array = [1570, 1571, 1572, 1573, 1574, 1575, 1576, 1577, 1578, 1579, 1580, 1581, 1582, 1583, 1584, 1585, 1586, 1587, 1588, 1589, 1590, 1591, 1592, 1593, 1594, 1600, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1608, 1609, 1610, 1662, 1670, 1688, 1705, 1711, 1728, 1740, 64342, 64343, 64344, 64345, 64378, 64379, 64380, 64381, 64394, 64395, 64398, 64399, 64400, 64401, 64402, 64403, 64404, 64405, 64420, 64421, 64508, 64509, 64510, 64511, 65153, 65154, 65155, 65156, 65157, 65158, 65159, 65160, 65161, 65162, 65163, 65164, 65165, 65166, 65167, 65168, 65169, 65170, 65171, 65172, 65173, 65174, 65175, 65176, 65177, 65178, 65179, 65180, 65181, 65182, 65183, 65184, 65185, 65186, 65187, 65188, 65189, 65190, 65191, 65192, 65193, 65194, 65195, 65196, 65197, 65198, 65199, 65200, 65201, 65202, 65203, 65204, 65205, 65206, 65207, 65208, 65209, 65210, 65211, 65212, 65213, 65214, 65215, 65216, 65217, 65218, 65219, 65220, 65221, 65222, 65223, 65224, 65225, 65226, 65227, 65228, 65229, 65230, 65231, 65232, 65233, 65234, 65235, 65236, 65237, 65238, 65239, 65240, 65241, 65242, 65243, 65244, 65245, 65246, 65247, 65248, 65249, 65250, 65251, 65252, 65253, 65254, 65255, 65256, 65257, 65258, 65259, 65260, 65261, 65262, 65263, 65264, 65265, 65266, 65267, 65268, 65269, 65270, 65271, 65272, 65273, 65274, 65275, 65276];
			
			var preChar1:int = -1;
			var preChar2:int = -1;
			var preChar3:int = -1;
			var preChar4:int = -1;
			
			var pastChar1:int = -1;
			var pastChar2:int = -1;
			var pastChar3:int = -1;
			var pastChar4:int = -1;
			
			var i:int = 0;
			var lng:int = 0;
			
			if ($i == 0) preSticking = 0;
			else if ($i == 1)
			{
				preChar1 = $text.charCodeAt($i - 1);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
			}
			else if ($i == 2)
			{
				preChar1 = $text.charCodeAt($i - 1);
				preChar2 = $text.charCodeAt($i - 2);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
				
				if (preSticking == -1)
				{
					lng = preNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (preChar1 == preNotStickArr[i])
						{
							preSticking = 0;
							break;
						}
					}
					
					if (preSticking == -1)
					{
						lng = preStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (preChar2 == preStickArr[i])
							{
								preSticking = 1;
								break;
							}
						}
					}
				}
			}
			else if ($i == 3)
			{
				preChar1 = $text.charCodeAt($i - 1);
				preChar2 = $text.charCodeAt($i - 2);
				preChar3 = $text.charCodeAt($i - 3);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
				
				if (preSticking == -1)
				{
					lng = preNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (preChar1 == preNotStickArr[i])
						{
							preSticking = 0;
							break;
						}
					}
					
					if (preSticking == -1)
					{
						lng = preStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (preChar2 == preStickArr[i])
							{
								preSticking = 1;
								break;
							}
						}
						
						if (preSticking == -1)
						{
							lng = preNotStickArr.length;
							
							for (i = 0; i < lng; i++) 
							{
								if (preChar2 == preNotStickArr[i])
								{
									preSticking = 0;
									break;
								}
							}
							
							if (preSticking == -1)
							{
								lng = preStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (preChar3 == preStickArr[i])
									{
										preSticking = 1;
										break;
									}
								}
							}
						}
					}
				}
			}
			else if ($i > 3)
			{
				preChar1 = $text.charCodeAt($i - 1);
				preChar2 = $text.charCodeAt($i - 2);
				preChar3 = $text.charCodeAt($i - 3);
				preChar4 = $text.charCodeAt($i - 4);
				
				lng = preStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (preChar1 == preStickArr[i])
					{
						preSticking = 1;
						break;
					}
				}
				
				if (preSticking == -1)
				{
					lng = preNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (preChar1 == preNotStickArr[i])
						{
							preSticking = 0;
							break;
						}
					}
					
					if (preSticking == -1)
					{
						lng = preStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (preChar2 == preStickArr[i])
							{
								preSticking = 1;
								break;
							}
						}
						
						if (preSticking == -1)
						{
							lng = preNotStickArr.length;
							
							for (i = 0; i < lng; i++) 
							{
								if (preChar2 == preNotStickArr[i])
								{
									preSticking = 0;
									break;
								}
							}
							
							if (preSticking == -1)
							{
								lng = preStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (preChar3 == preStickArr[i])
									{
										preSticking = 1;
										break;
									}
								}
							}
							
							if (preSticking == -1)
							{
								lng = preNotStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (preChar3 == preNotStickArr[i])
									{
										preSticking = 0;
										break;
									}
								}
								
								if (preSticking == -1)
								{
									lng = preStickArr.length;
									
									for (i = 0; i < lng; i++) 
									{
										if (preChar4 == preStickArr[i])
										{
											preSticking = 1;
											break;
										}
									}
								}
							}
						}
					}
				}
			}
			
			if ($i == ($text.length - 1)) nextSticking = 0;
			else if ($i == ($text.length - 2))
			{
				pastChar1 = $text.charCodeAt($i + 1);
				
				lng = pastStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (pastChar1 == pastStickArr[i])
					{
						nextSticking = 1;
						break;
					}
				}
			}
			else if ($i == ($text.length - 3))
			{
				pastChar1 = $text.charCodeAt($i + 1);
				pastChar2 = $text.charCodeAt($i + 2);
				
				lng = pastStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (pastChar1 == pastStickArr[i])
					{
						nextSticking = 1;
						break;
					}
				}
				
				if (nextSticking == -1)
				{
					lng = pastNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (pastChar1 == pastNotStickArr[i])
						{
							nextSticking = 0;
							break;
						}
					}
					
					if (nextSticking == -1)
					{
						lng = pastStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (pastChar2 == pastStickArr[i])
							{
								nextSticking = 1;
								break;
							}
						}
					}
				}
			}
			else if ($i == ($text.length - 4))
			{
				pastChar1 = $text.charCodeAt($i + 1);
				pastChar2 = $text.charCodeAt($i + 2);
				pastChar3 = $text.charCodeAt($i + 3);
				
				lng = pastStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (pastChar1 == pastStickArr[i])
					{
						nextSticking = 1;
						break;
					}
				}
				
				if (nextSticking == -1)
				{
					lng = pastNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (pastChar1 == pastNotStickArr[i])
						{
							nextSticking = 0;
							break;
						}
					}
					
					if (nextSticking == -1)
					{
						lng = pastStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (pastChar2 == pastStickArr[i])
							{
								nextSticking = 1;
								break;
							}
						}
						
						if (nextSticking == -1)
						{
							lng = pastNotStickArr.length;
							
							for (i = 0; i < lng; i++) 
							{
								if (pastChar2 == pastNotStickArr[i])
								{
									nextSticking = 0;
									break;
								}
							}
							
							if (nextSticking == -1)
							{
								lng = pastStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (pastChar3 == pastStickArr[i])
									{
										nextSticking = 1;
										break;
									}
								}
							}
						}
					}
				}
			}
			else if ($i < ($text.length - 4))
			{
				pastChar1 = $text.charCodeAt($i + 1);
				pastChar2 = $text.charCodeAt($i + 2);
				pastChar3 = $text.charCodeAt($i + 3);
				pastChar4 = $text.charCodeAt($i + 4);
				
				lng = pastStickArr.length;
				
				for (i = 0; i < lng; i++) 
				{
					if (pastChar1 == pastStickArr[i])
					{
						nextSticking = 1;
						break;
					}
				}
				
				if (nextSticking == -1)
				{
					lng = pastNotStickArr.length;
					
					for (i = 0; i < lng; i++) 
					{
						if (pastChar1 == pastNotStickArr[i])
						{
							nextSticking = 0;
							break;
						}
					}
					
					if (nextSticking == -1)
					{
						lng = pastStickArr.length;
						
						for (i = 0; i < lng; i++) 
						{
							if (pastChar2 == pastStickArr[i])
							{
								nextSticking = 1;
								break;
							}
						}
						
						if (nextSticking == -1)
						{
							lng = pastNotStickArr.length;
							
							for (i = 0; i < lng; i++) 
							{
								if (pastChar2 == pastNotStickArr[i])
								{
									nextSticking = 0;
									break;
								}
							}
							
							if (nextSticking == -1)
							{
								lng = pastStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (pastChar3 == pastStickArr[i])
									{
										nextSticking = 1;
										break;
									}
								}
							}
							
							if (nextSticking == -1)
							{
								lng = pastNotStickArr.length;
								
								for (i = 0; i < lng; i++) 
								{
									if (pastChar3 == pastNotStickArr[i])
									{
										nextSticking = 0;
										break;
									}
								}
								
								if (nextSticking == -1)
								{
									lng = pastStickArr.length;
									
									for (i = 0; i < lng; i++) 
									{
										if (pastChar4 == pastStickArr[i])
										{
											nextSticking = 1;
											break;
										}
									}
								}
							}
						}
					}
				}
			}
			
			if (preSticking == 1 && nextSticking == 1) loc = MIDDLE_STICKING;
			else if (preSticking == 1) loc = END_STICKING;
			else if (nextSticking == 1) loc = BEGINNING_STICKING;
			else loc = SEPARATE;
			
			return loc;
		}
		
		public static function changeNumber($text:String):String
		{
			var text:String = "";
			
			if ($text.search("0") == -1 && $text.search("1") == -1 && $text.search("2") == -1 && $text.search("3") == -1 && $text.search("4") == -1 && $text.search("5") == -1 && $text.search("6") == -1 && $text.search("7") == -1 && $text.search("8") == -1 && $text.search("9") == -1 && $text.search("A") == -1 && $text.search("B") == -1 && $text.search("C") == -1 && $text.search("D") == -1 && $text.search("E") == -1 && $text.search("F") == -1 && $text.search("G") == -1 && $text.search("H") == -1 && $text.search("I") == -1 && $text.search("J") == -1 && $text.search("K") == -1 && $text.search("L") == -1 && $text.search("M") == -1 && $text.search("N") == -1 && $text.search("O") == -1 && $text.search("P") == -1 && $text.search("Q") == -1 && $text.search("R") == -1 && $text.search("S") == -1 && $text.search("T") == -1 && $text.search("U") == -1 && $text.search("V") == -1 && $text.search("W") == -1 && $text.search("X") == -1 && $text.search("Y") == -1 && $text.search("Z") == -1 && $text.search("a") == -1 && $text.search("b") == -1 && $text.search("c") == -1 && $text.search("d") == -1 && $text.search("e") == -1 && $text.search("f") == -1 && $text.search("g") == -1 && $text.search("h") == -1 && $text.search("i") == -1 && $text.search("j") == -1 && $text.search("k") == -1 && $text.search("l") == -1 && $text.search("m") == -1 && $text.search("n") == -1 && $text.search("o") == -1 && $text.search("p") == -1 && $text.search("q") == -1 && $text.search("r") == -1 && $text.search("s") == -1 && $text.search("t") == -1 && $text.search("u") == -1 && $text.search("v") == -1 && $text.search("w") == -1 && $text.search("x") == -1 && $text.search("y") == -1 && $text.search("z") == -1 && $text.search("{") == -1 && $text.search("}") == -1 && $text.search("×") == -1 && $text.search("÷") == -1 && $text.search("!") == -1 && $text.search("%") == -1 && $text.search("^") == -1 && $text.search("*") == -1 && $text.search("/") == -1 && $text.search("+") == -1 && $text.search("-") == -1 && $text.search("=") == -1 && $text.search("(") == -1 && $text.search(")") == -1 && $text.search("<") == -1 && $text.search(">") == -1 && $text.search("[") == -1 && $text.search("]") == -1)
			{
				text = $text;
			}
			else 
			{
				var i:int = 0;
				var j:int = 0;
				var changeText:String = "";
				var lng:int = $text.length;
				
				for (i = 0; i < lng; i++) 
				{
					if ($text.charAt(i) == "0" || $text.charAt(i) == "1" || $text.charAt(i) == "2" || $text.charAt(i) == "3" || $text.charAt(i) == "4" || $text.charAt(i) == "5" || $text.charAt(i) == "6" || $text.charAt(i) == "7" || $text.charAt(i) == "8" || $text.charAt(i) == "9" || $text.charAt(i) == "A" || $text.charAt(i) == "B" || $text.charAt(i) == "C" || $text.charAt(i) == "D" || $text.charAt(i) == "E" || $text.charAt(i) == "F" || $text.charAt(i) == "G" || $text.charAt(i) == "H" || $text.charAt(i) == "I" || $text.charAt(i) == "J" || $text.charAt(i) == "K" || $text.charAt(i) == "L" || $text.charAt(i) == "M" || $text.charAt(i) == "N" || $text.charAt(i) == "O" || $text.charAt(i) == "P" || $text.charAt(i) == "Q" || $text.charAt(i) == "R" || $text.charAt(i) == "S" || $text.charAt(i) == "T" || $text.charAt(i) == "U" || $text.charAt(i) == "V" || $text.charAt(i) == "W" || $text.charAt(i) == "X" || $text.charAt(i) == "Y" || $text.charAt(i) == "Z" || $text.charAt(i) == "a" || $text.charAt(i) == "b" || $text.charAt(i) == "c" || $text.charAt(i) == "d" || $text.charAt(i) == "e" || $text.charAt(i) == "f" || $text.charAt(i) == "g" || $text.charAt(i) == "h" || $text.charAt(i) == "i" || $text.charAt(i) == "j" || $text.charAt(i) == "k" || $text.charAt(i) == "l" || $text.charAt(i) == "m" || $text.charAt(i) == "n" || $text.charAt(i) == "o" || $text.charAt(i) == "p" || $text.charAt(i) == "q" || $text.charAt(i) == "r" || $text.charAt(i) == "s" || $text.charAt(i) == "t" || $text.charAt(i) == "u" || $text.charAt(i) == "v" || $text.charAt(i) == "w" || $text.charAt(i) == "x" || $text.charAt(i) == "y" || $text.charAt(i) == "z" || $text.charAt(i) == "{" || $text.charAt(i) == "}" || $text.charAt(i) == "×" || $text.charAt(i) == "÷" || $text.charAt(i) == "!" || $text.charAt(i) == "%" || $text.charAt(i) == "^" || $text.charAt(i) == "*" || $text.charAt(i) == "/" || $text.charAt(i) == "+" || $text.charAt(i) == "-" || $text.charAt(i) == "=" || $text.charAt(i) == "(" || $text.charAt(i) == ")" || $text.charAt(i) == "<" || $text.charAt(i) == ">" || $text.charAt(i) == "[" || $text.charAt(i) == "]")
					{
						//trace("1>>", $text.charAt(i), i)
						for (j = i; j < lng; j++) 
						{
							//trace("2>>", $text.charAt(j), j)
							if ($text.charAt(j) == "0" || $text.charAt(j) == "1" || $text.charAt(j) == "2" || $text.charAt(j) == "3" || $text.charAt(j) == "4" || $text.charAt(j) == "5" || $text.charAt(j) == "6" || $text.charAt(j) == "7" || $text.charAt(j) == "8" || $text.charAt(j) == "9" || $text.charAt(j) == "." || $text.charAt(j) == "/" || $text.charAt(j) == "*" || $text.charAt(j) == "-" || $text.charAt(j) == "+" || $text.charAt(j) == "=" || $text.charAt(j) == "A" || $text.charAt(j) == "B" || $text.charAt(j) == "C" || $text.charAt(j) == "D" || $text.charAt(j) == "E" || $text.charAt(j) == "F" || $text.charAt(j) == "G" || $text.charAt(j) == "H" || $text.charAt(j) == "I" || $text.charAt(j) == "J" || $text.charAt(j) == "K" || $text.charAt(j) == "L" || $text.charAt(j) == "M" || $text.charAt(j) == "N" || $text.charAt(j) == "O" || $text.charAt(j) == "P" || $text.charAt(j) == "Q" || $text.charAt(j) == "R" || $text.charAt(j) == "S" || $text.charAt(j) == "T" || $text.charAt(j) == "U" || $text.charAt(j) == "V" || $text.charAt(j) == "W" || $text.charAt(j) == "X" || $text.charAt(j) == "Y" || $text.charAt(j) == "Z" || $text.charAt(j) == "a" || $text.charAt(j) == "b" || $text.charAt(j) == "c" || $text.charAt(j) == "d" || $text.charAt(j) == "e" || $text.charAt(j) == "f" || $text.charAt(j) == "g" || $text.charAt(j) == "h" || $text.charAt(j) == "i" || $text.charAt(j) == "j" || $text.charAt(j) == "k" || $text.charAt(j) == "l" || $text.charAt(j) == "m" || $text.charAt(j) == "n" || $text.charAt(j) == "o" || $text.charAt(j) == "p" || $text.charAt(j) == "q" || $text.charAt(j) == "r" || $text.charAt(j) == "s" || $text.charAt(j) == "t" || $text.charAt(j) == "u" || $text.charAt(j) == "v" || $text.charAt(j) == "w" || $text.charAt(j) == "x" || $text.charAt(j) == "y" || $text.charAt(j) == "z" || $text.charAt(j) == "{" || $text.charAt(j) == "}" || $text.charAt(j) == "×" || $text.charAt(j) == "÷" || $text.charAt(j) == "!" || $text.charAt(j) == "%" || $text.charAt(j) == "^" || $text.charAt(j) == "*" || $text.charAt(j) == "/" || $text.charAt(j) == "+" || $text.charAt(j) == "-" || $text.charAt(j) == "=" || $text.charAt(j) == "(" || $text.charAt(j) == ")" || $text.charAt(j) == "<" || $text.charAt(j) == ">" || $text.charAt(j) == "[" || $text.charAt(j) == "]")
							{
								changeText = $text.charAt(j) + changeText;
								i ++;
								//trace("3>>", changeText)
							}
							else
							{
								text += changeText;
								changeText = "";
								//trace("4>>", text)
								break;
							}
							
							if (j == lng - 1) text += changeText;
						}
					}
					else
					{
						text += $text.charAt(i);
					}
				}
			}
			
			return text;
		}
		
	}

}