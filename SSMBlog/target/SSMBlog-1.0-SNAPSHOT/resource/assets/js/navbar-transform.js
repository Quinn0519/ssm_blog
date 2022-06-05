// 导航栏样式改变、头图3D效果JS代码
document.body.onscroll = function () {
    if (document.documentElement.scrollTop > 10) {
        document.getElementById("navbar").className = "navbar-bottom";
    } else {
        document.getElementById("navbar").className = "navbar-top";
    };
    if (document.documentElement.scrollTop > 10 && document.documentElement.scrollTop < 1030) {
        document.getElementById("content").style.transform = 'translate3d(0,' + jQuery(window).scrollTop() / 5 + 'px,0)'
    }
    if (document.documentElement.scrollTop < 2) {
        document.getElementById("content").style.transform = 'translate3d(0,0,0)'
    } else { }
}