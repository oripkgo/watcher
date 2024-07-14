package com.watcher.common;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.stream.Stream;

@Component
public class ScheduledTasks {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());


    @Autowired
    private Environment env;



//    // 관련 게시물 추천 조회로 생성된 파일 찌거기 제거
//    // 매일 오전 2시에 실행
//    @Scheduled(cron = "0 0 3 * * ?")
//    public void taskRecommendedRelatedPostsRemovalDebris() {
//        Path directory = Paths.get(env.getProperty("upload.temp-storage.index01")); // 인덱스 디렉토리 경로
//        LocalDateTime today = LocalDate.now().atStartOfDay();
//        LocalDateTime yesterday = today.minusDays(1);
//
//        // try-with-resources 문법을 사용하여 스트림을 자동으로 닫습니다.
//        try (Stream<Path> walk = Files.walk(directory)) {
//            walk.filter(Files::isRegularFile)
//                    .filter(file -> {
//                        try {
//                            BasicFileAttributes attrs = Files.readAttributes(file, BasicFileAttributes.class);
//                            LocalDateTime fileTime = LocalDateTime.ofInstant(attrs.lastModifiedTime().toInstant(), ZoneId.systemDefault());
//                            return fileTime.isBefore(yesterday);
//                        } catch (IOException e) {
//                            logger.error("Failed to read file attributes for: " + file, e); // 로그로 예외 처리
//                            return false;
//                        }
//                    })
//                    .forEach(file -> {
//                        try {
//                            Files.delete(file); // 파일 삭제
//                            logger.info("Deleted file: " + file);
//                        } catch (IOException e) {
//                            logger.error("Failed to delete file: " + file, e); // 로그로 예외 처리
//                        }
//                    });
//        } catch (IOException e) {
//            logger.error("Failed to walk directory: " + directory, e); // 로그로 예외 처리
//        }
//    }


//    // 매 10초마다 실행
//    @Scheduled(fixedRate = 10000)
//    @Scheduled(initialDelay = 5000, fixedRate = 30000)
//    public void task1() {
//        System.out.println("Task 1 executed at " + new Date());
//    }
//
//    // 매 30초마다 실행 (초기 지연 5초)
//    @Scheduled(initialDelay = 5000, fixedRate = 30000)
//    public void task2() {
//        System.out.println("Task 2 executed at " + new Date());
//    }
//
//    // 매일 오전 2시에 실행
//    @Scheduled(cron = "0 0 2 * * ?")
//    public void task3() {
//        System.out.println("Task 3 executed at " + new Date());
//    }

}
