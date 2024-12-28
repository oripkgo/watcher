package com.watcher.enums;

public enum MemberType {
    NAVER("naver", "00"),
    KAKAO("kakao", "01");

    private final String name;
    private final String code;

    // 생성자
    MemberType(String name, String code) {
        this.name = name;
        this.code = code;
    }

    // 이름 반환
    public String getName() {
        return name;
    }

    // 코드 반환
    public String getCode() {
        return code;
    }


    // 코드로 Enum 찾기
    public static MemberType fromCode(String code) {
        for (MemberType type : MemberType.values()) {
            if (type.code.equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Invalid code: " + code);
    }

    // 이름으로 Enum 찾기
    public static MemberType fromName(String name) {
        for (MemberType type : MemberType.values()) {
            if (type.name.equalsIgnoreCase(name)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Invalid name: " + name);
    }

}
