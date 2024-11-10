package com.watcher.util;

import lombok.extern.log4j.Log4j2;
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
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;
import org.jsoup.Jsoup;

import java.io.IOException;
import java.util.*;

@Log4j2
public class RecommendUtil implements AutoCloseable {

    private final Directory directory;
    private final Analyzer analyzer;
    private final IndexWriter writer;
    private final SearcherManager searcherManager;

    public RecommendUtil() throws IOException {
        this.directory = new ByteBuffersDirectory();
        this.analyzer = new StandardAnalyzer();
        this.writer = new IndexWriter(directory, new IndexWriterConfig(analyzer));
        this.searcherManager = new SearcherManager(writer, true, true, null);
    }

    public void addDocumentList(List<Map<String, Object>> dataList) throws IOException {
        for (Map<String, Object> data : dataList) {
            String docId = data.get("ID").toString();
            String htmlContent = data.get("CONTENTS").toString();
            String textContent = Jsoup.parse(htmlContent).text(); // HTML에서 텍스트 추출

            IndexSearcher searcher = searcherManager.acquire();
            try {
                Query query = new TermQuery(new Term("docId", docId));
                TopDocs results = searcher.search(query, 1);

                if (results.totalHits.value == 0) {
                    Document doc = new Document();
                    doc.add(new StringField("docId", docId, Field.Store.YES)); // 문서 키 추가
                    doc.add(new TextField("content", textContent, Field.Store.YES));
                    writer.addDocument(doc);
                }
            } finally {
                searcherManager.release(searcher);
            }
        }
        writer.commit();
        searcherManager.maybeRefresh(); // 인덱스 변경 시에만 갱신
    }

    public List<String> searchSimilarDocuments(String newHtmlDocument, int topN) throws IOException, ParseException {
        String queryStr = Jsoup.parse(newHtmlDocument).text();

        if (queryStr.isEmpty()) {
            return new ArrayList<>();
        }

        IndexSearcher searcher = searcherManager.acquire();
        try {
            QueryParser parser = new QueryParser("content", analyzer);
            Query query = parser.parse(QueryParserBase.escape(queryStr));

            ScoreDoc[] hits = searcher.search(query, topN).scoreDocs;
            Set<String> uniqueDocIds = new LinkedHashSet<>();
            for (ScoreDoc hit : hits) {
                Document doc = searcher.doc(hit.doc);
                String docId = doc.get("docId");
                uniqueDocIds.add(docId);
            }
            return new ArrayList<>(uniqueDocIds);
        } finally {
            searcherManager.release(searcher);
        }
    }

    @Override
    public void close() throws IOException {
        if (searcherManager != null) {
            searcherManager.close();
        }
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
