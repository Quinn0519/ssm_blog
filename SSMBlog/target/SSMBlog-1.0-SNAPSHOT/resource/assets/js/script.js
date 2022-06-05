$(document).ready(function () {
    // 搜索
    $(".nav-search").click(function () {
        $("#search-main").fadeToggle(300);
    });

    // 菜单
    $(".nav-mobile").click(function () {
        $("#mobile-nav").slideToggle(500);
    });


    // 分享 √
    if (/iphone|ipod|ipad|ipad|mobile/i.test(navigator.userAgent.toLowerCase())) {
        $('.share-sd').click(function () {
            $('#share').animate({
                    opacity: 'toggle',
                    top: '-80px'
                },
                500).animate({
                    top: '-60px'
                },
                'fast');
            return false;
        });
    } else {
        $(".share-sd").mouseover(function () {
            $(this).children("#share").show();
        });
        $(".share-sd").mouseout(function () {
            $(this).children("#share").hide();
        });
    }


    // 去边线
    $(".message-widget li:last, .message-page li:last, .hot_commend li:last, .search-page li:last, .my-comment li:last, .message-tab li:last").css("border", "none");


    // 字号 √
    $("#fontsize").click(function () {
        var _this = $(this);
        var _t = $(".single-content");
        var _c = _this.attr("class");
        if (_c == "size_s") {
            _this.removeClass("size_s").addClass("size_l");
            _this.text("A+");
            _t.removeClass("fontsmall").addClass("fontlarge");
        } else {
            _this.removeClass("size_l").addClass("size_s");
            _this.text("A-");
            _t.removeClass("fontlarge").addClass("fontsmall");
        }
        ;
    });


// 结束
});


// 隐藏侧边
function pr() {
    var R = document.getElementById("sidebar");
    var L = document.getElementById("primary");
    if (R.className == "sidebar") {
        R.className = "sidebar-hide";
        L.className = "";
    } else {
        R.className = "sidebar";
        L.className = "primary";
    }
}

//微信二维码
$("#weixin_btn").click(function () {
    //页面层-微信二维码
    layer.open({
        type: 1,
        title: false,
        closeBtn: 0,
        area: '516px',
        skin: 'layui-layer-nobg', //没有背景色
        shadeClose: true,
        content: $('#weixin_code'),
        end: function () {
            $("#weixin_code").attr("style", "display:none;")
        }
    });
});

//获取相对路径
// function  getPath(){
//     var pathName = document.location.pathname;
//     var index = pathName.substr(1).indexOf("/");
//     var result = pathName.substr(0,index+1);
//     return result;
// }


// 文字滚动
(function ($) {
    $.fn.textSlider = function (settings) {
        settings = jQuery.extend({
                speed: "normal",
                line: 2,
                timer: 1000
            },
            settings);
        return this.each(function () {
            $.fn.textSlider.scllor($(this), settings)
        })
    };
    $.fn.textSlider.scllor = function ($this, settings) {
        var ul = $("ul:eq(0)", $this);
        var timerID;
        var li = ul.children();
        var _btnUp = $(".up:eq(0)", $this);
        var _btnDown = $(".down:eq(0)", $this);
        var liHight = $(li[0]).height();
        var upHeight = 0 - settings.line * liHight;
        var scrollUp = function () {
            _btnUp.unbind("click", scrollUp);
            ul.animate({
                    marginTop: upHeight
                },
                settings.speed,
                function () {
                    for (i = 0; i < settings.line; i++) {
                        ul.find("li:first").appendTo(ul)
                    }
                    ul.css({
                        marginTop: 0
                    });
                    _btnUp.bind("click", scrollUp)
                })
        };
        var scrollDown = function () {
            _btnDown.unbind("click", scrollDown);
            ul.css({
                marginTop: upHeight
            });
            for (i = 0; i < settings.line; i++) {
                ul.find("li:last").prependTo(ul)
            }
            ul.animate({
                    marginTop: 0
                },
                settings.speed,
                function () {
                    _btnDown.bind("click", scrollDown)
                })
        };
        var autoPlay = function () {
            timerID = window.setInterval(scrollUp, settings.timer)
        };
        var autoStop = function () {
            window.clearInterval(timerID)
        };
        ul.hover(autoStop, autoPlay).mouseout();
        _btnUp.css("cursor", "pointer").click(scrollUp);
        _btnUp.hover(autoStop, autoPlay);
        _btnDown.css("cursor", "pointer").click(scrollDown);
        _btnDown.hover(autoStop, autoPlay)
    }
})(jQuery);

$("#scrolldiv").textSlider({line: 1, speed: 300, timer: 6000});

function confirmDelete() {
    var msg = "您确定要删除吗？";
    if (confirm(msg) == true) {
        return true;
    } else {
        return false;
    }
}

//退出登录
function logout() {
    $.ajax({
        async: false,
        type: "POST",
        url: '/admin/logout',
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        dataType: "text",
        complete: function () {
            window.location.reload();
        }
    })
}

//申请友情链接
$("#applyLinkForm").submit(function () {
    $.ajax({
        async: false,
        type: "POST",
        url: '/applyLinkSubmit',
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        data: $("#applyLinkForm").serialize(),
        success: function () {
            alert("申请成功，请耐心等待审核！");
        }
    })
})
