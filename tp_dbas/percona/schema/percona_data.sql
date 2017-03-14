CREATE DATABASE IF NOT EXISTS `percona_data`;

USE `percona_data`;

CREATE TABLE IF NOT EXISTS `dsns` (
    `id` int NOT NULL AUTO_INCREMENT,
    `parent_id` int DEFAULT NULL,
    `dsn` varchar(255) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';

CREATE TABLE IF NOT EXISTS `checksums` (
   `db` char(64) NOT NULL,
   `tbl` char(64) NOT NULL,
   `chunk` int NOT NULL,
   `chunk_time` float NULL,
   `chunk_index` varchar(200) NULL,
   `lower_boundary` text NULL,
   `upper_boundary` text NULL,
   `this_crc` char(40) NOT NULL,
   `this_cnt` int NOT NULL,
   `master_crc` char(40) NULL,
   `master_cnt` int NULL,
   `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`db`, `tbl`, `chunk`),
   INDEX `ts_db_tbl` (`ts`, `db`, `tbl`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';

CREATE TABLE IF NOT EXISTS `query_review_history` (
    `checksum` BIGINT UNSIGNED NOT NULL,
    `sample` TEXT NOT NULL,
    KEY (`checksum`)    
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';

CREATE TABLE IF NOT EXISTS `query_history` (
    checksum             BIGINT UNSIGNED NOT NULL,
    sample               TEXT NOT NULL,
    ts_min               DATETIME,
    ts_max               DATETIME,
    ts_cnt               FLOAT,
    Query_time_sum       FLOAT,
    Query_time_min       FLOAT,
    Query_time_max       FLOAT,
    Query_time_pct_95    FLOAT,
    Query_time_stddev    FLOAT,
    Query_time_median    FLOAT,
    Lock_time_sum        FLOAT,
    Lock_time_min        FLOAT,
    Lock_time_max        FLOAT,
    Lock_time_pct_95     FLOAT,
    Lock_time_stddev     FLOAT,
    Lock_time_median     FLOAT,
    Rows_sent_sum        FLOAT,
    Rows_sent_min        FLOAT,
    Rows_sent_max        FLOAT,
    Rows_sent_pct_95     FLOAT,
    Rows_sent_stddev     FLOAT,
    Rows_sent_median     FLOAT,
    Rows_examined_sum    FLOAT,
    Rows_examined_min    FLOAT,
    Rows_examined_max    FLOAT,
    Rows_examined_pct_95 FLOAT,
    Rows_examined_stddev FLOAT,
    Rows_examined_median FLOAT,
    -- Percona extended slowlog attributes
    -- http://www.percona.com/docs/wiki/patches:slow_extended
    Rows_affected_sum             FLOAT,
    Rows_affected_min             FLOAT,
    Rows_affected_max             FLOAT,
    Rows_affected_pct_95          FLOAT,
    Rows_affected_stddev          FLOAT,
    Rows_affected_median          FLOAT,
    Rows_read_sum                 FLOAT,
    Rows_read_min                 FLOAT,
    Rows_read_max                 FLOAT,
    Rows_read_pct_95              FLOAT,
    Rows_read_stddev              FLOAT,
    Rows_read_median              FLOAT,
    Merge_passes_sum              FLOAT,
    Merge_passes_min              FLOAT,
    Merge_passes_max              FLOAT,
    Merge_passes_pct_95           FLOAT,
    Merge_passes_stddev           FLOAT,
    Merge_passes_median           FLOAT,
    InnoDB_IO_r_ops_min           FLOAT,
    InnoDB_IO_r_ops_max           FLOAT,
    InnoDB_IO_r_ops_pct_95        FLOAT,
    InnoDB_IO_r_ops_stddev        FLOAT,
    InnoDB_IO_r_ops_median        FLOAT,
    InnoDB_IO_r_bytes_min         FLOAT,
    InnoDB_IO_r_bytes_max         FLOAT,
    InnoDB_IO_r_bytes_pct_95      FLOAT,
    InnoDB_IO_r_bytes_stddev      FLOAT,
    InnoDB_IO_r_bytes_median      FLOAT,
    InnoDB_IO_r_wait_min          FLOAT,
    InnoDB_IO_r_wait_max          FLOAT,
    InnoDB_IO_r_wait_pct_95       FLOAT,
    InnoDB_IO_r_wait_stddev       FLOAT,
    InnoDB_IO_r_wait_median       FLOAT,
    InnoDB_rec_lock_wait_min      FLOAT,
    InnoDB_rec_lock_wait_max      FLOAT,
    InnoDB_rec_lock_wait_pct_95   FLOAT,
    InnoDB_rec_lock_wait_stddev   FLOAT,
    InnoDB_rec_lock_wait_median   FLOAT,
    InnoDB_queue_wait_min         FLOAT,
    InnoDB_queue_wait_max         FLOAT,
    InnoDB_queue_wait_pct_95      FLOAT,
    InnoDB_queue_wait_stddev      FLOAT,
    InnoDB_queue_wait_median      FLOAT,
    InnoDB_pages_distinct_min     FLOAT,
    InnoDB_pages_distinct_max     FLOAT,
    InnoDB_pages_distinct_pct_95  FLOAT,
    InnoDB_pages_distinct_stddev  FLOAT,
    InnoDB_pages_distinct_median  FLOAT,
    -- Boolean (Yes/No) attributes.  Only the cnt and sum are needed
    -- for these.  cnt is how many times is attribute was recorded,
    -- and sum is how many of those times the value was Yes.  So
    -- sum/cnt * 100 equals the percentage of recorded times that
    -- the value was Yes.
    QC_Hit_cnt          FLOAT,
    QC_Hit_sum          FLOAT,
    Full_scan_cnt       FLOAT,
    Full_scan_sum       FLOAT,
    Full_join_cnt       FLOAT,
    Full_join_sum       FLOAT,
    Tmp_table_cnt       FLOAT,
    Tmp_table_sum       FLOAT,
    Tmp_table_on_disk_cnt FLOAT,
    Tmp_table_on_disk_sum FLOAT,
    Filesort_cnt          FLOAT,
    Filesort_sum          FLOAT,
    Filesort_on_disk_cnt  FLOAT,
    Filesort_on_disk_sum  FLOAT,
    PRIMARY KEY(`checksum`, `ts_min`, `ts_max`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';

CREATE TABLE IF NOT EXISTS `query_review` (
   `checksum` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
   `fingerprint` TEXT NOT NULL,
   `sample` TEXT NOT NULL,
   `first_seen` DATETIME,
   `last_seen`  DATETIME,
   `reviewed_by` VARCHAR(20),
   `reviewed_on` DATETIME,
   `comments` TEXT,
    KEY (`checksum`)    
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';

