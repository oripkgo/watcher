const NAVIGATION = function () {

    const profileImgUrlEmpty = "/resources/img/member_ico_b.png";
    let profileImgUrl = profileImgUrlEmpty;

    const generateNotLoginNavigatorHTML = function () {
        let naviHtml = '<a v-else href="javascript:;" class="btn_start loginStart" onclick="comm.navigation.handleLogin()">시작하기</a>';

        return (new DOMParser().parseFromString(naviHtml, 'text/html').querySelector(".loginStart"));
    }

    const generateLoginProfileHTML = function () {
        let naviHtml = '';
        naviHtml += '<a href="javascript:;" class="member_set logout" onclick="comm.navigation.handleProfile()">';
        naviHtml += '<img src="' + profileImgUrl + '">';
        naviHtml += '</a>';
        return (new DOMParser().parseFromString(naviHtml, 'text/html').querySelector(".member_set"));
    }

    const generateLoginNavigatorHTML = function (menuList) {
        let naviHtml = '';

        naviHtml += '<div class="member_app logout" style="display: none;">';

        if (menuList) {
            for (const menu of menuList) {
                const name = menu.name;
                const url = menu.url;
                naviHtml += '<a href="' + url + '">' + name + '</a>';
            }
        }

        naviHtml += '<a href="javascript:;" id="logout" onclick="comm.navigation.handleLogout()">로그아웃</a>';
        naviHtml += '</div>';

        return (new DOMParser().parseFromString(naviHtml, 'text/html').querySelector(".member_app"));
    }

    const emptyTarget = function (target) {
        while (target.firstChild) {
            target.removeChild(target.firstChild);
        }
    }

    const init = function (targetArea, menuList, signObj) {
        this.signObj = signObj;
        const naviThis = this;

        emptyTarget(targetArea);

        this.signObj.init();

        if (this.signObj.isLogin()) {
            naviThis.setProfileUrl(this.signObj.getSession().memProfileImg);
            targetArea.appendChild(generateLoginProfileHTML())
            targetArea.appendChild(generateLoginNavigatorHTML(menuList))
        } else {
            targetArea.appendChild(generateNotLoginNavigatorHTML())
        }
    }

    const handleLogin = function () {
        this.signObj.in();
    }

    const handleLogout = function () {
        const $this = this;
        MESSAGE.confirm("로그아웃 하시겠습니까?", function (result) {
            if (result) {
                $this.signObj.out();
            }
        });
    }

    const handleProfile = function () {
        $(".member_app").slideToggle("fast");
    }

    const setProfileUrl = function (imgUrl) {
        profileImgUrl = imgUrl;
    }

    return {

        init: init,

        handleLogin: handleLogin,

        handleLogout: handleLogout,

        handleProfile: handleProfile,

        setProfileUrl: setProfileUrl

    }

}()

