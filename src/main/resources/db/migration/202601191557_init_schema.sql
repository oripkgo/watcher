-- watcher.BOARD_LIKE definition

CREATE TABLE `BOARD_LIKE`
(
    `ID`            int(11) NOT NULL AUTO_INCREMENT,
    `CONTENTS_TYPE` char(20)     DEFAULT NULL,
    `CONTENTS_ID`   int(11) DEFAULT NULL,
    `LOGIN_ID`      varchar(100) DEFAULT NULL,
    `LIKE_TYPE`     varchar(2)   DEFAULT NULL COMMENT '추천 타입( 좋아요 01, 싫어요 02)',
    `CANCEL_YN`     varchar(1)   DEFAULT 'N',
    `REG_ID`        varchar(100) DEFAULT NULL,
    `REG_DATE`      datetime     DEFAULT NULL,
    `UPT_ID`        varchar(100) DEFAULT NULL,
    `UPT_DATE`      datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8mb4;


-- watcher.BOARD_TAGS definition

CREATE TABLE `BOARD_TAGS`
(
    `ID`            int(11) NOT NULL AUTO_INCREMENT,
    `CONTENTS_TYPE` char(20) NOT NULL,
    `CONTENTS_ID`   int(11) NOT NULL,
    `TAGS`          varchar(200) DEFAULT NULL,
    `DELETE_YN`     char(1)      DEFAULT 'N' COMMENT '삭제여부',
    `REG_ID`        varchar(100) DEFAULT NULL,
    `REG_DATE`      datetime     DEFAULT NULL,
    `UPT_ID`        varchar(100) DEFAULT NULL,
    `UPT_DATE`      datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `UNIQUE_BOARD_TAGS_01` (`CONTENTS_TYPE`,`CONTENTS_ID`,`TAGS`),
    KEY             `IDX_BOARD_TAGS_01` (`TAGS`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4;


-- watcher.CATEGORY definition

CREATE TABLE `CATEGORY`
(
    `ID`                int(11) NOT NULL AUTO_INCREMENT,
    `CATEGORY_NM`       varchar(50) NOT NULL,
    `CATEGORY_COMENTS`  varchar(100) DEFAULT NULL,
    `CATEGORY_IMG_PATH` varchar(200) DEFAULT NULL,
    `SHOW_YN`           varchar(200) DEFAULT 'Y' COMMENT '카테고리 노출여부',
    `SORT`              char(2)      DEFAULT '99' COMMENT '정렬순서',
    `DELETE_YN`         char(1)      DEFAULT 'N' COMMENT '삭제여부',
    `REG_ID`            varchar(100) DEFAULT NULL,
    `REG_DATE`          datetime     DEFAULT NULL,
    `UPT_ID`            varchar(100) DEFAULT NULL,
    `UPT_DATE`          datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `CATEGORY_NM` (`CATEGORY_NM`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;


-- watcher.COMMENT definition

CREATE TABLE `COMMENT`
(
    `ID`              int(11) NOT NULL AUTO_INCREMENT,
    `CONTENTS_TYPE`   char(20) NOT NULL,
    `CONTENTS_ID`     int(11) NOT NULL,
    `REF_CONTENTS_ID` int(11) DEFAULT NULL,
    `COMMENT`         text         DEFAULT NULL,
    `CONFIRM_ID`      varchar(100) DEFAULT NULL,
    `DELETE_YN`       char(1)      DEFAULT 'N',
    `REG_ID`          varchar(100) DEFAULT NULL,
    `REG_DATE`        datetime     DEFAULT NULL,
    `UPT_ID`          varchar(100) DEFAULT NULL,
    `UPT_DATE`        datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=322 DEFAULT CHARSET=utf8mb4;


-- watcher.FILE_RESOURCE definition

CREATE TABLE `FILE_RESOURCE`
(
    `ID`               int(11) NOT NULL AUTO_INCREMENT,
    `CONTENTS_TYPE`    char(20) NOT NULL,
    `CONTENTS_ID`      int(11) NOT NULL,
    `REAL_FILE_NAME`   varchar(200) DEFAULT NULL,
    `SERVER_FILE_NAME` varchar(500) DEFAULT NULL,
    `SAVE_PATH`        varchar(500) DEFAULT NULL,
    `DELETE_YN`        char(1)      DEFAULT 'N',
    `PATH_SEPARATOR`   char(1)      DEFAULT '/',
    `REG_ID`           varchar(100) DEFAULT NULL,
    `REG_DATE`         datetime     DEFAULT NULL,
    `UPT_ID`           varchar(100) DEFAULT NULL,
    `UPT_DATE`         datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb4;


-- watcher.`MEMBER` definition

CREATE TABLE `MEMBER`
(
    `ID`              int(11) NOT NULL AUTO_INCREMENT COMMENT '회원 아이디',
    `LOGIN_ID`        varchar(100) DEFAULT NULL,
    `PASSWORD`        varchar(500) DEFAULT NULL,
    `EMAIL`           varchar(100) DEFAULT NULL,
    `PHONE_NUM`       varchar(11)  DEFAULT NULL,
    `BIRTH`           char(8)      DEFAULT NULL COMMENT '생년월일',
    `GENDER`          char(1)      DEFAULT NULL COMMENT '성별 (1:남자,2:여자)',
    `NAME`            varchar(50)  DEFAULT NULL,
    `NICKNAME`        char(50)     DEFAULT NULL COMMENT '별명',
    `MEM_TYPE`        char(2)      DEFAULT NULL COMMENT '회원 유형 (00:NAVER, 01:KAKAO)',
    `MEM_PROFILE_IMG` varchar(300) DEFAULT NULL,
    `REG_ID`          varchar(100) DEFAULT NULL,
    `REG_DATE`        datetime     DEFAULT NULL,
    `UPT_ID`          varchar(100) DEFAULT NULL,
    `UPT_DATE`        datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `LOGIN_ID` (`LOGIN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4;


-- watcher.MEMBER_DETAIL definition

CREATE TABLE `MEMBER_DETAIL`
(
    `ID`       int(11) NOT NULL AUTO_INCREMENT,
    `LOGIN_ID` varchar(100) DEFAULT NULL,
    `REG_ID`   varchar(100) DEFAULT NULL,
    `REG_DATE` datetime     DEFAULT NULL,
    `UPT_ID`   varchar(100) DEFAULT NULL,
    `UPT_DATE` datetime     DEFAULT NULL,
    `LEVEL`    int(11) DEFAULT 1,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `MEM_ID` (`LOGIN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4;


-- watcher.MEMBER_LEVEL definition

CREATE TABLE `MEMBER_LEVEL`
(
    `ID`         int(11) NOT NULL AUTO_INCREMENT,
    `REG_ID`     varchar(100) DEFAULT NULL,
    `REG_DATE`   datetime     DEFAULT NULL,
    `UPT_ID`     varchar(100) DEFAULT NULL,
    `UPT_DATE`   datetime     DEFAULT NULL,
    `LEVEL_NAME` varchar(20) NOT NULL,
    `LEVEL`      int(11) DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;


-- watcher.MEMBER_MANAGEMENT definition

CREATE TABLE `MEMBER_MANAGEMENT`
(
    `ID`                          int(11) NOT NULL AUTO_INCREMENT,
    `LOGIN_ID`                    varchar(100) NOT NULL,
    `COMMENT_PERM_STATUS`         char(2)      NOT NULL DEFAULT '01' COMMENT '스토리 댓글 권한 (01:전체, 02:작성자)',
    `STORY_REG_PERM_STATUS`       char(2)      NOT NULL DEFAULT '01' COMMENT '스토리 등록 권한 (01:전체, 02:작성자)',
    `STORY_COMMENT_PUBLIC_STATUS` char(2)      NOT NULL DEFAULT '01' COMMENT '스토리 댓글 공개 여부 (01:공개, 02:비공개)',
    `STORY_TITLE`                 varchar(15)  NOT NULL COMMENT '스토리 이름',
    `REG_ID`                      varchar(100)          DEFAULT NULL,
    `REG_DATE`                    datetime              DEFAULT NULL,
    `UPT_ID`                      varchar(100)          DEFAULT NULL,
    `UPT_DATE`                    datetime              DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `MEM_ID` (`LOGIN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;


-- watcher.NOTICE definition

CREATE TABLE `NOTICE`
(
    `ID`                 int(11) NOT NULL AUTO_INCREMENT COMMENT '공지사항 키',
    `TITLE`              varchar(100) NOT NULL COMMENT '제목',
    `CONTENTS`           text         DEFAULT NULL COMMENT '내용',
    `THUMBNAIL_IMG_PATH` varchar(200) DEFAULT NULL COMMENT '썸네일 이미지 경로',
    `DELETE_YN`          char(1)      DEFAULT 'N' COMMENT '삭제여부',
    `SECRET_YN`          char(1)      DEFAULT 'N' COMMENT '공개여부',
    `VIEW_CNT`           int(11) DEFAULT 0 COMMENT '조회 갯수',
    `LIKE_CNT`           int(11) DEFAULT 0 COMMENT '좋아요 갯수',
    `COMMENT_CNT`        int(11) DEFAULT 0 COMMENT '댓글 갯수',
    `ADMIN_ID`           varchar(100) DEFAULT NULL COMMENT '게시글 관리자 ID',
    `REG_ID`             varchar(100) DEFAULT NULL COMMENT '등록 아이디',
    `REG_DATE`           datetime     DEFAULT NULL COMMENT '등록 일자',
    `UPT_ID`             varchar(100) DEFAULT NULL COMMENT '수정 아이디',
    `UPT_DATE`           datetime     DEFAULT NULL COMMENT '수정 일자',
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4;


-- watcher.SEARCH_TERMS definition

CREATE TABLE `SEARCH_TERMS`
(
    `ID`          int(11) NOT NULL AUTO_INCREMENT COMMENT '검색어 키',
    `SEARCH_DATE` char(8)      DEFAULT date_format(current_timestamp(), '%Y%m%d') COMMENT '검색용 날짜',
    `CLIENT_IP`   varchar(100) DEFAULT NULL COMMENT '방문자 IP',
    `CLIENT_ID`   varchar(150) DEFAULT NULL COMMENT '클라이언트 아이디',
    `KEYWORD`     varchar(100) DEFAULT NULL COMMENT '키워드',
    `REG_ID`      varchar(100) DEFAULT NULL,
    `REG_DATE`    datetime     DEFAULT NULL,
    `UPT_ID`      varchar(100) DEFAULT NULL,
    `UPT_DATE`    datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `SEARCH_TERMS_UNIQUE_01` (`CLIENT_IP`,`SEARCH_DATE`,`KEYWORD`),
    UNIQUE KEY `SEARCH_TERMS_UNIQUE_02` (`CLIENT_ID`,`SEARCH_DATE`,`KEYWORD`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4;


-- watcher.STORY definition

CREATE TABLE `STORY`
(
    `ID`                 int(11) NOT NULL AUTO_INCREMENT,
    `CATEGORY_ID`        char(11)     NOT NULL,
    `MEMBER_CATEGORY_ID` char(11)     DEFAULT NULL,
    `TITLE`              varchar(100) NOT NULL,
    `CONTENTS`           mediumtext   NOT NULL,
    `VIEW_CNT`           int(11) DEFAULT 0 COMMENT '조회 갯수',
    `LIKE_CNT`           int(11) DEFAULT 0 COMMENT '좋아요 갯수',
    `COMMENT_CNT`        int(11) DEFAULT 0 COMMENT '댓글 갯수',
    `THUMBNAIL_IMG_ID`   char(11)     DEFAULT NULL,
    `SUMMARY`            varchar(600) DEFAULT NULL,
    `DELETE_YN`          char(1)      DEFAULT 'N',
    `SECRET_YN`          char(1)      DEFAULT 'N' COMMENT '공개 여부',
    `ADMIN_ID`           varchar(100) DEFAULT NULL COMMENT '게시글 관리자 ID',
    `REG_ID`             varchar(100) DEFAULT NULL,
    `REG_DATE`           datetime     DEFAULT NULL,
    `UPT_ID`             varchar(100) DEFAULT NULL,
    `UPT_DATE`           datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8mb4;


-- watcher.USER_DEFINE_CATEGORY definition

CREATE TABLE `USER_DEFINE_CATEGORY`
(
    `ID`                int(11) NOT NULL AUTO_INCREMENT,
    `DEFALUT_CATEG_ID`  int(11) NOT NULL,
    `LOGIN_ID`          varchar(100) DEFAULT NULL,
    `CATEGORY_NM`       varchar(50)  DEFAULT NULL,
    `CATEGORY_COMENTS`  varchar(100) DEFAULT NULL,
    `CATEGORY_IMG_PATH` varchar(200) DEFAULT NULL,
    `SHOW_YN`           char(1)      DEFAULT 'Y',
    `DELETE_YN`         char(1)      DEFAULT 'N' COMMENT '삭제여부',
    `REG_ID`            varchar(100) DEFAULT NULL,
    `REG_DATE`          datetime     DEFAULT NULL,
    `UPT_ID`            varchar(100) DEFAULT NULL,
    `UPT_DATE`          datetime     DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4;


-- watcher.VISITOR_HISTORY definition

CREATE TABLE `VISITOR_HISTORY`
(
    `ID`                 int(11) NOT NULL AUTO_INCREMENT COMMENT '키',
    `ACCESS_PATH`        varchar(1000) DEFAULT NULL COMMENT '사이트 접속 경로',
    `ACCESS_TARGET`      varchar(20)   DEFAULT 'local' COMMENT '사이트 대상(naver, daum, yahoo)',
    `ACC_PAGE_URL`       varchar(1000) DEFAULT NULL COMMENT '접속된 페이지 URL',
    `CLIENT_IP`          varchar(100)  DEFAULT NULL COMMENT '방문자 IP',
    `CLIENT_ID`          varchar(150)  DEFAULT NULL COMMENT '클라이언트 아이디',
    `CALL_SERVICE`       varchar(100)  DEFAULT NULL COMMENT '호출한 서비스',
    `VISIT_STORY_MEM_ID` varchar(100)  DEFAULT NULL COMMENT '방문 스토리 회원 아이디',
    `REG_YEAR_INQUIRY`   varchar(4)    DEFAULT date_format(current_timestamp(), '%Y') COMMENT '조회용 등록년도',
    `REG_MONTH_INQUIRY`  varchar(6)    DEFAULT date_format(current_timestamp(), '%Y%m') COMMENT '조회용 등록월수',
    `REG_DATE_INQUIRY`   varchar(8)    DEFAULT date_format(current_timestamp(), '%Y%m%d') COMMENT '조회용 등록일자',
    `REG_DATE`           datetime      DEFAULT current_timestamp() COMMENT '등록 일자',
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14582 DEFAULT CHARSET=utf8mb4;