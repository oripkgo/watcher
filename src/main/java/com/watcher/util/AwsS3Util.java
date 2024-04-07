package com.watcher.util;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;

@Component
public class AwsS3Util {


    private final static Logger logger = LoggerFactory.getLogger(AwsS3Util.class);


    private static String bucketUrl;


    private static String bucketName;


    private static String imageType = MediaType.IMAGE_PNG_VALUE;


    @Value("${aws.bucket.url}")
    private void setBucketUrl(String url) {
        bucketUrl = url;
    }


    @Value("${aws.bucket.name}")
    private void setBucketName(String bucket) {
        bucketName = bucket;
    }


    static public String getBucketUrl() {
        return bucketUrl;
    }


    static public void putImage(String path, InputStream is)throws Exception{

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType(imageType);
        try {
            metadata.setContentLength(is.available());
        } catch (IOException e) {
            throw e;
        }

        try {
            final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
                    .withCredentials(new ProfileCredentialsProvider())
                    .withRegion(Regions.AP_NORTHEAST_2)
                    .build();
            s3.putObject(
                    new PutObjectRequest(
                            bucketName
                            , path
                            , is
                            , metadata
                    )
            );
        } catch (AmazonServiceException e) {
            logger.error(e.getErrorMessage(), e);
            throw e;
        }
    }

}
