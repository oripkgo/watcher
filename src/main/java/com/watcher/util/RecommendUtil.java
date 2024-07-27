package com.watcher.util;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.queryparser.classic.QueryParserBase;
import org.apache.lucene.search.*;
import org.apache.lucene.search.similarities.BM25Similarity;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.MMapDirectory;
import org.jsoup.Jsoup;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

public class RecommendUtil {

    private Path                indexPath;
    private Directory           directory;
    private Analyzer            analyzer;
    private IndexWriterConfig   config;


    public RecommendUtil(String path) throws Exception {
        indexPath = Paths.get(path);
        this.directory = new MMapDirectory(indexPath);
        this.analyzer = new StandardAnalyzer();
        this.config = new IndexWriterConfig(analyzer);
    }


    public void addDocumentList(List<Map<String, Object>> dataList) throws IOException {

        try (
            IndexWriter writer = new IndexWriter(directory, config);
            IndexReader reader = DirectoryReader.open(directory);
        ) {
            for (Map<String, Object> data : dataList) {
                String docId        = data.get("ID").toString();
                String htmlContent  = data.get("CONTENTS").toString();
                String textContent  = Jsoup.parse(htmlContent).text(); // HTML에서 텍스트 추출

                // 문서 키 중복 확인
                Query query = new TermQuery(new Term("docId", docId));

                IndexSearcher searcher = new IndexSearcher(reader);
                TopDocs results = searcher.search(query, 1);

                if (results.totalHits.value == 0) { // 키가 존재하지 않을 때만 추가
                    Document doc = new Document();
                    doc.add(new StringField("docId", docId, Field.Store.YES)); // 문서 키 추가
                    doc.add(new TextField("content", textContent, Field.Store.YES));
                    writer.addDocument(doc);
                }
            }

        }

    }


    public List<String> searchSimilarDocuments(String newHtmlDocument, int topN) throws IOException, ParseException {
        String queryStr = Jsoup.parse(newHtmlDocument).text(); // HTML에서 텍스트 추출

        try (IndexReader reader = DirectoryReader.open(directory)) {
            IndexSearcher searcher = new IndexSearcher(reader);
            searcher.setSimilarity(new BM25Similarity());
            QueryParser parser = new QueryParser("content", analyzer);

            // 쿼리 문자열 이스케이프
            Query query = parser.parse( QueryParserBase.escape(queryStr) );

            ScoreDoc[] hits = searcher.search(query, topN).scoreDocs;
            Set<String> uniqueDocIds = new HashSet<>();
            List<String> result = new ArrayList<>();
            for (ScoreDoc hit : hits) {
                Document doc = searcher.doc(hit.doc);
                String docId = doc.get("docId");
                if (uniqueDocIds.add(docId)) { // 중복 키 필터링
                    result.add(docId); // 문서 키 반환
                }
            }
            return result;
        } catch (ParseException e) {
            // 예외 처리
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

}
