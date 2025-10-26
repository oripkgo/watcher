const NAVIGATION = function () {

    const profileImgUrlEmpty = "/resources/img/member_ico_b.png";
    let profileImgUrl = profileImgUrlEmpty;

    const generateNotLoginNavigatorHTML = function () {
        let naviHtml = '<button id="loginBtn" onclick="comm.navigation.handleLogin()">로그인</button>';
        return (new DOMParser().parseFromString(naviHtml, 'text/html').querySelector("#loginBtn"));
    }

    const generateProfileContainer = function(){
        return (new DOMParser().parseFromString('<div class="profile-container"></div>', 'text/html').querySelector(".profile-container"));
    }

    const generateLoginProfileHTML = function () {
        let naviHtml = '';

        naviHtml += '<div class="profile-wrapper" onClick="comm.navigation.handleProfile()">';
        naviHtml += '<img class="profile-img" src="' + profileImgUrl + '">';
        naviHtml += '</div>';
        return (new DOMParser().parseFromString(naviHtml, 'text/html').querySelector(".profile-wrapper"));
    }

    const generateLoginNavigatorHTML = function (menuList) {
        let naviHtml = '';
        naviHtml += '<ul class="profile-menu" id="profileMenu">';

        if (menuList) {
            for (const menu of menuList) {
                const name = menu.name;
                const url = menu.url;
                naviHtml += '<li><a href="' + url + '">' + name + '</a></li>';
            }
        }

        naviHtml += '<li><a href="javascript:;" id="logout" onclick="comm.navigation.handleLogout()">로그아웃</a></li>';
        naviHtml += '</ul>';

        return (new DOMParser().parseFromString(naviHtml, 'text/html').querySelector(".profile-menu"));
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

            const profileContainer = generateProfileContainer();
            profileContainer.appendChild(generateLoginProfileHTML())
            profileContainer.appendChild(generateLoginNavigatorHTML(menuList))
            targetArea.appendChild(profileContainer)

            $(document).on("click", function (e) {
                if (!$(e.target).closest(".profile-wrapper, .profile-menu").length) {
                    if ($(".profile-menu").is(":visible")) {
                        $(".profile-menu").slideUp("fast");
                    }
                }
            });

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
        $(".profile-menu").slideToggle("fast");
    }

    const setProfileUrl = function (imgUrl) {
        profileImgUrl = imgUrl;
    }

    return {

        init: init,

        handleLogin: handleLogin,

        handleLogout: handleLogout,

        handleProfile: handleProfile,

        setProfileUrl: setProfileUrl,

    }

}()

