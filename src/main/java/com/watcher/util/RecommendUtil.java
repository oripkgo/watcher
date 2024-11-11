package com.watcher.util;

import lombok.extern.log4j.Log4j2;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.core.SimpleAnalyzer;
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
        this.analyzer = new SimpleAnalyzer();
        this.writer = new IndexWriter(directory, new IndexWriterConfig(analyzer));
        this.searcherManager = new SearcherManager(writer, true, true, null);
    }


    // 여러 게시물 인덱싱
    public void addBlogPosts(List<Map<String, Object>> blogPosts) throws IOException {
        for (Map<String, Object> post : blogPosts) {
            String id = post.get("ID").toString();
            String content = post.get("CONTENTS").toString();

            Document doc = new Document();
            doc.add(new StringField("id", id, Field.Store.YES));
            doc.add(new TextField("content", Jsoup.parse(content).text(), Field.Store.YES)); // HTML 콘텐츠 텍스트 추출

            writer.addDocument(doc);
        }
        writer.commit();           // 전체 문서를 추가한 후 커밋
        searcherManager.maybeRefresh();
    }


    // 유사한 게시물 검색
    public List<String> findRelatedPosts(String content, int topN) throws IOException, ParseException {
        List<String> relatedPostIds = new ArrayList<>();

        // 텍스트 추출 및 검색 준비
        String searchText = Jsoup.parse(content).text();
        QueryParser parser = new QueryParser("content", analyzer);
        Query query = parser.parse(QueryParserBase.escape(searchText));

        // 유사 게시물 검색
        IndexSearcher searcher = searcherManager.acquire();
        try {
            TopDocs topDocs = searcher.search(query, topN);
            for (ScoreDoc scoreDoc : topDocs.scoreDocs) {
                Document doc = searcher.doc(scoreDoc.doc);
                relatedPostIds.add(doc.get("id"));  // 관련 게시물 ID 추가
            }
        } finally {
            searcherManager.release(searcher);
        }

        return relatedPostIds;
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
