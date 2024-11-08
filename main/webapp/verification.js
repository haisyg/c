function Verification(selector,width,height){
    //随机生成数字
    function rn(min,max){
        return parseInt(Math.random()*(max-min)+min)
    }
    //随机生成颜色
    function rc(min,max){
        var r=rn(min,max);
        var g=rn(min,max);
        var b=rn(min,max);
        return `rgb(${r},${g},${b})`
    }
    var width=120;
    var height=30;
    var canvas=document.querySelector('#canvas');
    var brush=canvas.getContext('2d');
    brush.fillStyle=rc(180,230)
    brush.fillRect(0,0,width,height)
    //生成随机字符串
    var pool='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var result=""
    for(var i=0;i<4;i++){
        var c=pool[rn(0,pool.length)]
        var fs=rn(20,35)//字体大小
        var deg=rn(-30,30);//旋转角度
        brush.font=fs+'px Simhei';
        brush.textBaseline='top';
        brush.fillStyle=rc(80,150);
        brush.save()
        brush.translate(30*i+15,15);
        brush.rotate(deg*Math.PI/180);
        brush.fillText(c,-10,-15);
        brush.restore()
        result+=c;
    }
    //随机生成干扰线
    for(var i=0;i<5;i++){
        brush.beginPath();//起始路径
        brush.moveTo(rn(0,width),rn(0,height));//起始位置
        brush.lineTo(rn(0,width),rn(0,height));//终点位置
        brush.strokeStyle=rc(130,250)//线的样式
        brush.closePath();
        brush.stroke()//绘制路线
    }
    //随机产生干扰圆点
    for(var i=0;i<40;i++){
        brush.beginPath();
        brush.arc(rn(0,width),rn(0,height),1,0,2*Math.PI);
        brush.closePath();
        brush.fillStyle=rc(130,200);
        brush.fill()
    }
    return result;
}
let verification=Verification('#canvas',120,30);
console.log(verification)
document.getElementById('generatedCaptcha').value = verification;