const DATE = {
    getDayOfTheWeek : function(date){
        const d = date;
        const weekday = [];new Array(7);
        weekday[0] = "일";
        weekday[1] = "월";
        weekday[2] = "화";
        weekday[3] = "수";
        weekday[4] = "목";
        weekday[5] = "금";
        weekday[6] = "토";

        return weekday[d.getDay()];
    },

    getToDay : function(format){
        return this.getDate(new Date(),format);
    },

    getDate : function(date,format){
        let date_format = format || ''

        let year = date.getFullYear(); // 년도
        let month = date.getMonth() + 1;  // 월
        let dt = date.getDate();  // 날짜
        let day = date.getDay();  // eslint-disable-line no-unused-vars
        // 요일


        month = ( "00"+month )
        month = month.substring(month.length-2,month.length);

        dt = ( "00"+dt )
        dt = dt.substring(dt.length-2,dt.length);

        return year + date_format + month + date_format + dt;
    },

    getPastDate : function(last_date){
        let write_date = new Date(last_date.replace(/[.]/g,'-')) ;
        let now_date = new Date();

        if( serverActivate == 'prod' ){
            // 운영환경일 경우
            write_date = new Date(write_date.getTime() + (9 * 60 * 60 * 1000));
        }

        if( this.getDate(now_date) != this.getDate(write_date)){
            write_date = new Date(this.getDate(write_date,'-')) ;
        }

        let last_time_result = now_date.getTime() - write_date.getTime();

        let floor = function(num){
            return Math.floor(num*1);
        }
        if( ( last_time_result/1000 ) < 60 ){

            if( last_time_result < 0 ){
                return "방금";
            }

            return floor(( last_time_result/1000 ))+"초 전";
        }

        if( ( last_time_result/1000/60 ) < 60 ){
            return floor(( last_time_result/1000/60 ))+'분 전';
        }

        if( ( last_time_result/1000/60/60 ) < 60 ){
            return floor(( last_time_result/1000/60/60 ))+'시간 전';
        }

        if( ( last_time_result/1000/60/60/24 ) < 365 ){
            return floor(( last_time_result/1000/60/60/24 ))+'일 전';
        }

        return floor(( last_time_result/1000/60/60/24/365 ))+'년 전';
    },

}
