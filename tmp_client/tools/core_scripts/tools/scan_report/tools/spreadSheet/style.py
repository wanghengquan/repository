from pyExcelerator import *

_cellBorderLineStyle = {'0' : 0x00,   # NO_LINE
                        #'1' : 0x01,   # THIN
                        '1' : 0x03,    # remove line
                        '2' : 0x02,   # MEDIUM
                        '3' : 0x03,   # DASHED
                        '4' : 0x04,   # DOTTED
                        '5' : 0x05,   # THICK
                        '6' : 0x06,   # DOUBLE
                        '7' : 0x07}   # HAIR
def createBorders(lineStyle='0000'):
    myBorders = Borders()
    lineStyleList = list(lineStyle)
    myBorders.top    = _cellBorderLineStyle[lineStyleList[0]]
    myBorders.bottom = _cellBorderLineStyle[lineStyleList[1]]
    myBorders.left   = _cellBorderLineStyle[lineStyleList[2]]
    myBorders.right  = _cellBorderLineStyle[lineStyleList[3]]
    return myBorders
_cellAlignmentStyle = {'100' : 0x01,  # left
                       '010' : 0x02,  # center
                       '001' : 0x03}  # right
def createAlignment(cellAlignment='100'):
    myAlignment = Alignment()
    myAlignment.horz = _cellAlignmentStyle[cellAlignment]
    myAlignment.vert = 0x01  # VERTICAL CENTER
    return myAlignment
def createPattern(cellPatternColour=''):
    myPattern = Pattern()
    if cellPatternColour:
        myPattern.pattern = 0x01
        myPattern.pattern_back_colour = cellPatternColour
        myPattern.pattern_fore_colour = cellPatternColour
    return myPattern
def createFont(cellFontColour='black', cellFontIsBold=False, cellFontSize=8):
    myFont = Font()
    myFont.colour_index = cellFontColour
    myFont.bold = cellFontIsBold
    myFont.height = cellFontSize * 20   # IN PIXEL
    return myFont
def createStyle(myBorders=createBorders(), myAlignment=createAlignment(), myPattern=createPattern(), myFont=createFont(), myFormat=''):
    myStyle = XFStyle()
    myStyle.borders = myBorders
    myStyle.alignment = myAlignment
    myStyle.pattern = myPattern
    myStyle.font = myFont
    if myFormat:
        myStyle.num_format_str = myFormat
    return myStyle
def myCreateStyle(myBorders='', myAlignment='', myPattern='', myFont='', myFormat=''):
    myStyle = XFStyle()
    if myBorders:
        myStyle.borders = createBorders(myBorders)
    else:
        myStyle.borders = createBorders()
    if myAlignment:
        myStyle.alignment = createAlignment(myAlignment)
    else:
        myStyle.alignment = createAlignment()
    if myPattern:
        myStyle.pattern = createPattern(myPattern)
    else:
        myStyle.pattern = createPattern()
    if myFont:
        
        myStyle.font = createFont(myFont)
    else:
        myStyle.font = createFont()
    if myFormat:
        myStyle.num_format_str = myFormat
    return myStyle
def default_sytle():
        defaultBorders = createBorders()
        borders2200 = createBorders('2200')
        borders1111 = createBorders('1111')
        borders3333 = createBorders('3333')
        borders2122 = createBorders('2122')
        defaultAlignment = createAlignment()
        #rightAlignment = createAlignment('001')
        centerAlignment = createAlignment('010')
        defaultPattern = createPattern()
        pattern0x2a = createPattern(0x2a)
        patternYellow = createPattern('yellow')
        defaultFont = createFont()
        fontBold = createFont(cellFontIsBold=True)
        defaultStyle = createStyle(defaultBorders, defaultAlignment, defaultPattern, defaultFont)