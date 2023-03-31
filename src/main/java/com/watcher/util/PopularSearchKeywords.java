package com.watcher.util;

import java.util.*;

public class PopularSearchKeywords {

    public static void main(String[] args) {
        List<String> keywords = new ArrayList<>();

        Scanner scanner = new Scanner(System.in);

        while(true){
            if( keywords.size() == 10 ){
                break;
            }

            System.out.print("검색어를 입력하세요: ");
            String input = scanner.nextLine();

            keywords.add(input);
        }

        // 검색어 빈도수 구하기
        Map<String, Integer> frequencyMap = new HashMap<>();
        for (String keyword : keywords) {
            frequencyMap.put(keyword, frequencyMap.getOrDefault(keyword, 0) + 1);
        }

        // 빈도수로 내림차순 정렬하여 리스트에 저장
        List<Map.Entry<String, Integer>> sortedList = new ArrayList<>(frequencyMap.entrySet());
        sortedList.sort(Collections.reverseOrder(Map.Entry.comparingByValue()));

        List<String> popularKeywords = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : sortedList) {
            popularKeywords.add(entry.getKey());
        }

        System.out.println("인기 검색어: " + popularKeywords);
    }


}
