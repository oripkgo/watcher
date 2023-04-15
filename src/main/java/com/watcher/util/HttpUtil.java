package com.watcher.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;


public class HttpUtil {


    private final static Logger logger = LoggerFactory.getLogger(HttpUtil.class);


    static public String httpRequest(String UrlData, String method, Map<String,String> ParamData, Map<String,String> headersData ){

        //http 요청 시 url 주소와 파라미터 데이터를 결합하기 위한 변수 선언
        String totalUrl = UrlData.trim().toString();

        //http 통신을 하기위한 객체 선언 실시
        URL url = null;
        HttpURLConnection conn = null;

        //http 통신 요청 후 응답 받은 데이터를 담기 위한 변수
        String responseData = "";
        BufferedReader br = null;
        StringBuffer sb = null;

        //메소드 호출 결과값을 반환하기 위한 변수
        String returnData = "";

        try {
            //파라미터로 들어온 url을 사용해 connection 실시
            url = new URL(totalUrl);
            conn = (HttpURLConnection) url.openConnection();


            if (headersData != null) {

                Set key = headersData.keySet();

                for (Iterator iterator = key.iterator(); iterator.hasNext();) {
                    String keyName = (String) iterator.next();
                    String valueName = headersData.get(keyName);

                    //http 요청에 필요한 타입 정의 실시
                    conn.setRequestProperty(keyName, valueName);

                }
            }else{
                conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            }

            if( !method.isEmpty() ){
                conn.setRequestMethod(method);
            }else{
                conn.setRequestMethod("POST");
            }

            conn.setDoOutput(true);

            //http 요청 실시
            conn.connect();

            logger.debug("http 요청 방식 : "+"GET");
            logger.debug("http 요청 주소 : "+UrlData);
            logger.debug("http 요청 데이터 : "+ParamData);


            //--------------------------
            //   서버로 값 전송
            //--------------------------
            StringBuffer buffer = new StringBuffer();

            //HashMap으로 전달받은 파라미터가 null이 아닌경우 버퍼에 넣어준다
            if (ParamData != null) {

                Set key = ParamData.keySet();

                for (Iterator iterator = key.iterator(); iterator.hasNext();) {
                    String keyName = (String) iterator.next();
                    String valueName = ParamData.get(keyName);

                    if( !buffer.toString().isEmpty() ){
                        buffer.append("&");
                    }

                    buffer.append(keyName).append("=").append(valueName);
                }
            }

            OutputStreamWriter outStream = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
            PrintWriter writer = new PrintWriter(outStream);
            writer.write(buffer.toString());
            writer.flush();



            //http 요청 후 응답 받은 데이터를 버퍼에 쌓는다

            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            sb = new StringBuffer();
            while ((responseData = br.readLine()) != null) {
                sb.append(responseData); //StringBuffer에 응답받은 데이터 순차적으로 저장 실시
            }

            //메소드 호출 완료 시 반환하는 변수에 버퍼 데이터 삽입 실시
            returnData = sb.toString();

            //http 요청 응답 코드 확인 실시
            String responseCode = String.valueOf(conn.getResponseCode());
            System.out.println("http 응답 코드 : "+responseCode);
            System.out.println("http 응답 데이터 : "+returnData);

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            //http 요청 및 응답 완료 후 BufferedReader를 닫아줍니다
            try {
                if (br != null) {
                    br.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        return returnData;

    }

    static public String httpRequest(String UrlData, Map<String,String> ParamData, Map<String,String> headersData){
        return httpRequest(UrlData,"",ParamData, headersData);
    }

    static public String httpRequest(String UrlData, Map<String,String> ParamData){
        return httpRequest(UrlData,"",ParamData,null);
    }

}
