package com.watcher.util;

import com.watcher.util.AESUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
//@ActiveProfiles("dev")
public class AESUtilTest {

    @Test
    @DisplayName("AES 암복호화 테스트")
    void run() {
        String txt = "171";

        // 암호화
        String enc = AESUtil.encrypt(txt);
        System.out.println("enc : " + enc);

        // 복호화
        String dec = AESUtil.decrypt(enc);
        System.out.println("dec : " + dec);
    }
}
