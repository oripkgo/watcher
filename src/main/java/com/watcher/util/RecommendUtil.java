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
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;
import org.jsoup.Jsoup;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.*;

public class RecommendUtil implements AutoCloseable {

    private final Logger logger = LoggerFactory.getLogger(RecommendUtil.class);

    private final Directory directory;
    private final Analyzer analyzer;
    private final IndexWriter writer;

    public RecommendUtil() throws IOException {
        this.directory = new ByteBuffersDirectory();
        this.analyzer = new StandardAnalyzer();
        this.writer = new IndexWriter(directory, new IndexWriterConfig(analyzer));
    }

    public void addDocumentList(List<Map<String, Object>> dataList) throws IOException {
        try (IndexReader reader = DirectoryReader.open(writer)) {
            IndexSearcher searcher = new IndexSearcher(reader);
            for (Map<String, Object> data : dataList) {
                String docId = data.get("ID").toString();
                String htmlContent = data.get("CONTENTS").toString();
                String textContent = Jsoup.parse(htmlContent).text(); // HTML에서 텍스트 추출

                // 문서 키 중복 확인
                Query query = new TermQuery(new Term("docId", docId));
                TopDocs results = searcher.search(query, 1);

                if (results.totalHits.value == 0) { // 키가 존재하지 않을 때만 추가
                    Document doc = new Document();
                    doc.add(new StringField("docId", docId, Field.Store.YES)); // 문서 키 추가
                    doc.add(new TextField("content", textContent, Field.Store.YES));
                    writer.addDocument(doc);
                }
            }
        }
        writer.commit(); // 명시적으로 커밋
    }

    public List<String> searchSimilarDocuments(String newHtmlDocument, int topN) throws IOException, ParseException {
        String queryStr = Jsoup.parse(newHtmlDocument).text(); // HTML에서 텍스트 추출

        try (IndexReader reader = DirectoryReader.open(directory)) { // 수정된 부분
            IndexSearcher searcher = new IndexSearcher(reader);
            searcher.setSimilarity(new BM25Similarity());
            QueryParser parser = new QueryParser("content", analyzer);

            Query query = parser.parse(QueryParserBase.escape(queryStr));
            ScoreDoc[] hits = searcher.search(query, topN).scoreDocs;

            Set<String> uniqueDocIds = new LinkedHashSet<>(); // 중복을 제거하면서 순서 유지
            for (ScoreDoc hit : hits) {
                Document doc = searcher.doc(hit.doc);
                String docId = doc.get("docId");
                uniqueDocIds.add(docId); // 중복 키 필터링
            }
            return new ArrayList<>(uniqueDocIds); // 중복 제거된 결과 반환
        } catch (ParseException e) {
            logger.error("Failed to parse the query: {}", queryStr, e);
        } catch (IOException e) {
            logger.error("IOException occurred while searching documents", e);
        }
        return Collections.emptyList();
    }

    @Override
    public void close() throws IOException {
        if (writer != null) {
            writer.close();
        }
        if (directory != null) {
            directory.close();
        }
        if (analyzer != null) {
            analyzer.close();
        }
    }
}
