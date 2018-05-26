function jjencode(gv,text) {
    var r="";
    var n;
    var t;
    var b=[ "___", "__$", "_$_", "_$$", "$__", "$_$", "$$_", "$$$", "$___", "$__$", "$_$_", "$_$$", "$$__", "$$_$", "$$$_", "$$$$", ];
    var s = "";
    for( var i = 0; i < text.length; i++ ){
        n = text.charCodeAt( i );
        if( n == 0x22 || n == 0x5c ){
            s += "\\\\\\" + text.charAt( i ).toString(16);
        }else if( (0x21 <= n && n <= 0x2f) || (0x3A <= n && n <= 0x40) || ( 0x5b <= n && n <= 0x60 ) || ( 0x7b <= n && n <= 0x7f ) ){
        //}else if( (0x20 <= n && n <= 0x2f) || (0x3A <= n == 0x40) || ( 0x5b <= n && n <= 0x60 ) || ( 0x7b <= n && n <= 0x7f ) ){
            s += text.charAt( i );
        }else if( (0x30 <= n && n <= 0x39 ) || (0x61 <= n && n <= 0x66 ) ){
            if( s ) r += "\"" + s +"\"+";
            r += gv + "." + b[ n < 0x40 ? n - 0x30 : n - 0x57 ] + "+";
            s="";
        }else if( n == 0x6c ){ // 'l'
            if( s ) r += "\"" + s + "\"+";
            r += "(![]+\"\")[" + gv + "._$_]+";
            s = "";
        }else if( n == 0x6f ){ // 'o'
            if( s ) r += "\"" + s + "\"+";
            r += gv + "._$+";
            s = "";
        }else if( n == 0x74 ){ // 'u'
            if( s ) r += "\"" + s + "\"+";
            r += gv + ".__+";
            s = "";
        }else if( n == 0x75 ){ // 'u'
            if( s ) r += "\"" + s + "\"+";
            r += gv + "._+";
            s = "";
        }else if( n < 128 ){
            if( s ) r += "\"" + s;
            else r += "\"";
            r += "\\\\\"+" + n.toString( 8 ).replace( /[0-7]/g, function(c){ return gv + "."+b[ c ]+"+" } );
            s = "";
        }else{
            if( s ) r += "\"" + s;
            else r += "\"";
            r += "\\\\\"+" + gv + "._+" + n.toString(16).replace( /[0-9a-f]/gi, function(c){ return gv + "."+b[parseInt(c,16)]+"+"} );
            s = "";
        }
    }
    if( s ) r += "\"" + s + "\"+";

    r = 
    gv + "=~[];" + 
    gv + "={___:++" + gv +",$$$$:(![]+\"\")["+gv+"],__$:++"+gv+",$_$_:(![]+\"\")["+gv+"],_$_:++"+
    gv+",$_$$:({}+\"\")["+gv+"],$$_$:("+gv+"["+gv+"]+\"\")["+gv+"],_$$:++"+gv+",$$$_:(!\"\"+\"\")["+
    gv+"],$__:++"+gv+",$_$:++"+gv+",$$__:({}+\"\")["+gv+"],$$_:++"+gv+",$$$:++"+gv+",$___:++"+gv+",$__$:++"+gv+"};"+
    gv+".$_="+
    "("+gv+".$_="+gv+"+\"\")["+gv+".$_$]+"+
    "("+gv+"._$="+gv+".$_["+gv+".__$])+"+
    "("+gv+".$$=("+gv+".$+\"\")["+gv+".__$])+"+
    "((!"+gv+")+\"\")["+gv+"._$$]+"+
    "("+gv+".__="+gv+".$_["+gv+".$$_])+"+
    "("+gv+".$=(!\"\"+\"\")["+gv+".__$])+"+
    "("+gv+"._=(!\"\"+\"\")["+gv+"._$_])+"+
    gv+".$_["+gv+".$_$]+"+
    gv+".__+"+
    gv+"._$+"+
    gv+".$;"+
    gv+".$$="+
    gv+".$+"+
    "(!\"\"+\"\")["+gv+"._$$]+"+
    gv+".__+"+
    gv+"._+"+
    gv+".$+"+
    gv+".$$;"+
    gv+".$=("+gv+".___)["+gv+".$_]["+gv+".$_];"+
    gv+".$("+gv+".$("+gv+".$$+\"\\\"\"+" + r + "\"\\\"\")())();";

    return r;
};

function getnonalphanum_js(s) {
getRandom = function(minVal, maxVal) {    
     var randVal = minVal+(Math.random()*(maxVal-minVal));
    return Math.round(randVal);    
}

var symbols = ('ªÀÁÂÃÄÆÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ$_').split('');
                var func = '';
                var symbol = '$';
                var symbol1 = "$";    
                var symbol2 = "$$";    
                var symbol3 = "$$$";
                var symbol4 = "$$$$";
                var symbol5 = "$$$$$";
                var symbol6 = "$$$$$$";
                
                for(var i=0;i<6;i++) {
                    if (symbols.length > 0) {
                        var pos = getRandom(0, symbols.length - 1);
                        var symbol = symbols[pos];
                        symbols.splice(pos, 1);
                    } else {
                        symbol += symbol;
                    }
                    switch(i) {
                        case 0:
                            symbol1 = symbol;
                        break;
                        case 1:
                            symbol2 = symbol;
                        break;
                        case 2:
                            symbol3 = symbol;
                        break;
                        case 3:
                            symbol4 = symbol;
                        break;
                        case 4:
                            symbol5 = symbol;
                        break;
                        case 5:
                            symbol6 = symbol;
                        break;                                                                                                                        
                    }
                }
                                
                var nums = [symbol1+"-"+symbol1,symbol1+"-"+symbol2,symbol2,symbol1,symbol2+"+"+symbol2,symbol2+"+"+symbol1,symbol1+"+"+symbol1,symbol3,symbol4,symbol1+"*"+symbol1];                    
                func += symbol2+"=-~-~[],"+symbol1+"=-~"+symbol2+","+symbol4+"="+symbol2+"<<"+symbol2+","+symbol3+"="+symbol4+"+~[];";
                func += symbol5+"=("+nums[0]+")["+symbol6+"=(''+{})["+nums[5]+"]+(''+{})["+nums[1]+"]+([]."+symbol1+"+'')["+nums[1]+"]+(!!''+'')["+nums[3]+"]+({}+'')["+nums[6]+"]+(!''+'')["+nums[1]+"]+(!''+'')["+nums[2]+"]+(''+{})["+nums[5]+"]+({}+'')["+nums[6]+"]+(''+{})["+nums[1]+"]+(!''+'')["+nums[1]+"]]["+symbol6+"]";                
                
                s = s.replace(/.+/,function(c) {
                    var output = [];
                    c = c + '';
                    for (var j = 0; j < c.length; j++) {
                        var cc = c.charCodeAt(j).toString(8).split('');
                        for (var i = 0; i < cc.length; i++) {
                            cc[i] = "(" + nums[cc[i]] + ")";
                        }
                        output.push('\'\\\\\'+' + cc.join('+'));
                    }                                    
                    return "+"+symbol5+"((!''+'')["+nums[1]+"]+(!''+'')["+nums[3]+"]+(!''+'')["+nums[0]+"]+(!''+'')["+nums[2]+"]+((!''+''))["+nums[1]+"]+([].$+'')["+nums[1]+"]"+"+\'\\''"+"+"+'\'\'+'+output.join('+')+"+\'\\'')()";
                });
                return func+';'+''+symbol5+'('+s.replace(/^\+/,'')+')()';

}