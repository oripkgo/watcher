package com.watcher;


import org.jsoup.Jsoup;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.*;
import java.util.stream.Collectors;

@SpringBootTest
//@ActiveProfiles("dev")
public class RecommendUtilTest {

    // 유사도 임계값
    private static final double SIMILARITY_THRESHOLD = 0.1;


    @Test
    @DisplayName("관련 게시물 테스트")
    void runTest() {

        // 게시물 목록 (예시)
        List<Map<String, Object>> posts = new ArrayList<>();
        Map<String, Object> post1 = new HashMap<>();
        post1.put("ID", "1");
        post1.put("CONTENTS", "오늘 날씨가 좋다");
        posts.add(post1);

        Map<String, Object> post2 = new HashMap<>();
        post2.put("ID", "2");
        post2.put("CONTENTS", "비가 오는 날씨");
        posts.add(post2);

        Map<String, Object> post3 = new HashMap<>();
        post3.put("ID", "3");
        post3.put("CONTENTS", "오늘은 맑은 날씨입니다");
        posts.add(post3);

        String targetContent = "오늘 날씨가 맑다";

        // 관련 게시물 추출
        List<Map<String, Object>> relatedPosts = findRelatedPosts(posts, targetContent);

        // 관련 게시물 출력
        for (Map<String, Object> post : relatedPosts) {
            System.out.println("ID: " + post.get("ID") + ", 유사도: " + post.get("SIMILARITY"));
        }
    }


    // 관련 게시물 찾기
    public List<Map<String, Object>> findRelatedPosts(List<Map<String, Object>> posts, String targetContent) {
        // 타겟 게시물 벡터화
        Map<String, Integer> targetVector = tokenizeAndVectorize(targetContent);

        // 게시물들 중 유사도가 임계값 이상인 것들 추출
        return posts.stream()
                .map(post -> {
                    String content = post.get("CONTENTS").toString();
                    Map<String, Integer> postVector = tokenizeAndVectorize(content);
                    double similarity = calculateCosineSimilarity(targetVector, postVector);
                    post.put("SIMILARITY", similarity); // 유사도 추가
                    return post;
                })
                .filter(post -> (double) post.get("SIMILARITY") >= SIMILARITY_THRESHOLD) // 유사도가 임계값 이상인 것만
                .sorted((p1, p2) -> Double.compare((double) p2.get("SIMILARITY"), (double) p1.get("SIMILARITY"))) // 유사도 내림차순 정렬
                .collect(Collectors.toList());
    }

    // 코사인 유사도 계산
    private double calculateCosineSimilarity(Map<String, Integer> vec1, Map<String, Integer> vec2) {
        Set<String> allWords = new HashSet<>();
        allWords.addAll(vec1.keySet());
        allWords.addAll(vec2.keySet());

        int dotProduct = 0;
        double magnitude1 = 0;
        double magnitude2 = 0;

        for (String word : allWords) {
            int count1 = vec1.getOrDefault(word, 0);
            int count2 = vec2.getOrDefault(word, 0);
            dotProduct += count1 * count2;
            magnitude1 += Math.pow(count1, 2);
            magnitude2 += Math.pow(count2, 2);
        }

        // 벡터의 크기가 0일 경우 유사도를 0으로 처리
        if (magnitude1 == 0 || magnitude2 == 0) {
            return 0;
        }

        return dotProduct / (Math.sqrt(magnitude1) * Math.sqrt(magnitude2));
    }

    // 텍스트를 토큰화하고 벡터화
    // 텍스트를 토큰화하고 벡터화
    private Map<String, Integer> tokenizeAndVectorize(String content) {
        Map<String, Integer> vector = new HashMap<>();
        // 텍스트에서 알파벳, 숫자, 공백만 남기고 다른 특수문자는 제거
        String[] words = content.toLowerCase().replaceAll("[^a-z가-힣0-9\\s]", "").split("\\s+");

        // 공백 문자로 분할된 단어들에 대해 처리
        for (String word : words) {
            if (!word.trim().isEmpty()) { // 공백만 남은 단어는 제외
                vector.put(word, vector.getOrDefault(word, 0) + 1);
            }
        }
        return vector;
    }

}
