package com.watcher.util;

import lombok.extern.log4j.Log4j2;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@Log4j2
@Component
public class RecommendUtil {

    // 유사도 임계값
    private static final double SIMILARITY_THRESHOLD = 0.1;


    // 관련 게시물 찾기
    public List<Map<String, Object>> findRelatedPosts(List<Map<String, Object>> posts, String targetContent) {
        // 타겟 게시물 벡터화
        Map<String, Integer> targetVector = tokenizeAndVectorize(Jsoup.parse(targetContent).text());

        // 게시물들 중 유사도가 임계값 이상인 것들 추출
        return posts.stream()
                .map(post -> {
                    String content = Jsoup.parse(post.get("CONTENTS").toString()).text();
                    Map<String, Integer> postVector = tokenizeAndVectorize(content);

                    double similarity = calculateCosineSimilarity(targetVector, postVector);
//                    similarity += calculateAdditionalSimilarity(targetVector, postVector);

                    post.put("SIMILARITY", similarity); // 유사도 추가
                    return post;
                })
                .filter(post -> (double) post.get("SIMILARITY") >= SIMILARITY_THRESHOLD) // 유사도가 임계값 이상인 것만
                .sorted((p1, p2) -> Double.compare((double) p2.get("SIMILARITY"), (double) p1.get("SIMILARITY"))) // 유사도 내림차순 정렬
                .collect(Collectors.toList());
    }

    // 유사한 단어를 포함했을 때 점수 추가
    private double calculateAdditionalSimilarity(Map<String, Integer> targetVector, Map<String, Integer> postVector) {
        double additionalSimilarity = 0.0;

        // 벡터화된 데이터를 기반으로 유사한 단어가 있는지 확인
        for (String targetWord : targetVector.keySet()) {
            // postVector에서 targetWord와 유사한 단어가 있는지 확인 (부분 일치 or 유사 단어 처리)
            for (String postWord : postVector.keySet()) {
                if (isSimilar(targetWord, postWord)) {
                    // 두 벡터에서 유사한 단어가 있으면 점수 추가
                    additionalSimilarity += 0.1;  // 점수는 원하는 만큼 조정 가능
                }
            }
        }

        return additionalSimilarity;
    }

    // "유사한 단어"를 확인하는 함수 (부분 일치 처리)
    private boolean isSimilar(String targetWord, String postWord) {
        // 예시: targetWord와 postWord가 부분적으로 일치하는지 확인
        return postWord.contains(targetWord) || targetWord.contains(postWord);
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
