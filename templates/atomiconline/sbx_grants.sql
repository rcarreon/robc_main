CREATE DATABASE /*!32312 IF NOT EXISTS*/ `pb_mostcraved` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_gnmedia` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_hockeysfuture` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_playstationls` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_realitytea` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_thefashionspot` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_idlyitw` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_bufferzone` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_gnmedia` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_hockeysfuture` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_playstationls` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_realitytea` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_thefashionspot` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_idlyitw` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_bufferzone` /*!40100 DEFAULT CHARACTER SET utf8 */;

GRANT USAGE ON *.* TO 'pb_meta_w'@'localhost' IDENTIFIED BY 'HalCisOts1';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_gnmedia`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_hockeysfuture`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_playstationls`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_realitytea`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_thefashionspot`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_idlyitw`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_bufferzone`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_gnmedia`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_hockeysfuture`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_playstationls`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_realitytea`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_thefashionspot`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_idlyitw`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_bufferzone`.* TO 'pb_meta_w'@'localhost';

GRANT USAGE ON *.* TO 'pb_meta_r'@'localhost' IDENTIFIED BY 'OyWiv3edOi';
GRANT SELECT ON `wp_pb_beta_gnmedia`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_beta_hockeysfuture`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_beta_playstationls`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_beta_realitytea`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_beta_thefashionspot`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_beta_idlyitw`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_beta_bufferzone`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_gnmedia`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_hockeysfuture`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_playstationls`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_realitytea`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_thefashionspot`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_idlyitw`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON `wp_pb_bufferzone`.* TO 'pb_meta_r'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_gnmedia`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE on wp_pb_hockeysfuture.* to 'hockeysfuture_w'@'localhost' identified by 'S983D65c82';
GRANT SELECT on wp_pb_hockeysfuture.* to 'hockeysfuture_r'@'localhost' identified by 'aM2tF68SA4';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_hockeysfuture`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE on wp_pb_gnmedia.* to 'gnmedia_w'@'localhost' identified by '29a58v39bg';
GRANT SELECT on wp_pb_gnmedia.* to 'gnmedia_r'@'localhost' identified by 'JFgQX52TMH';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_gnmedia`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_playstationls.* TO 'playstationls_w'@'localhost' IDENTIFIED BY 'e36Y7vuq45';
GRANT SELECT ON wp_pb_playstationls.* TO 'playstationls_r'@'localhost' IDENTIFIED BY '5Z7dh25P8f';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_playstationls`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_realitytea.* TO 'realitytea_w'@'localhost' IDENTIFIED BY '7d98aE7KN8';
GRANT SELECT ON wp_pb_realitytea.* TO 'realitytea_r'@'localhost' IDENTIFIED BY '9F7AJ3V5dw';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_realitytea`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_thefashionspot.* TO 'thefashionspot_w'@'localhost' IDENTIFIED BY 'H2u3W9PSQAc3';
GRANT SELECT ON wp_pb_thefashionspot.* TO 'thefashionspot_r'@'localhost' IDENTIFIED BY '5976ZVJSr794';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_thefashionspot`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_craveonline` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_craveonline`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_craveonline`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_craveonline.* TO 'craveonline_w'@'localhost' IDENTIFIED BY 'RL3k964ZD7a8';
GRANT SELECT ON wp_pb_craveonline.* TO 'craveonline_r'@'localhost' IDENTIFIED BY 'k5eqF87BuhJc';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_craveonline`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_craveonline` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_craveonline`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_beta_craveonline.* TO 'bt_craveonline_w'@'localhost' IDENTIFIED BY 'a4GN5xh278GW';
GRANT SELECT ON `wp_pb_beta_craveonline`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT ON wp_pb_beta_craveonline.* TO 'bt_craveonline_r'@'localhost' IDENTIFIED BY 'qu92fmLE568v';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_craveonline`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_bufferzone.* TO 'bufferzone_w'@'localhost' IDENTIFIED BY '3P67F1XmQZaq';
GRANT SELECT ON wp_pb_bufferzone.* TO 'bufferzone_r'@'localhost' IDENTIFIED BY '4xSYAfnp3apz';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_bufferzone`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE on wp_pb_beta_hockeysfuture.* to 'bt_hockeysfutu_w'@'localhost' identified by 'MtEBLH69Vx';
GRANT SELECT on wp_pb_beta_hockeysfuture.* to 'bt_hockeysfutu_r'@'localhost' identified by '968YL5Qx8y';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_hockeysfuture`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_beta_playstationls.* TO 'bt_playstation_w'@'localhost' IDENTIFIED BY '7sK2d6E8K7';
GRANT SELECT ON wp_pb_beta_playstationls.* TO 'bt_playstation_r'@'localhost' IDENTIFIED BY '64JayPM3C4';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_playstationls`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_beta_realitytea.* TO 'bt_realitytea_w'@'localhost' IDENTIFIED BY 'Kws2Day65W';
GRANT SELECT ON wp_pb_beta_realitytea.* TO 'bt_realitytea_r'@'localhost' IDENTIFIED BY '9L3Z2Bk6MW';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_realitytea`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_beta_thefashionspot.* TO 'bt_thefashions_w'@'localhost' IDENTIFIED BY '6xan7u8Ck65d';
GRANT SELECT ON wp_pb_beta_thefashionspot.* TO 'bt_thefashions_r'@'localhost' IDENTIFIED BY 'UyH3LnT9487e';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_thefashionspot`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_beta_bufferzone.* TO 'bt_bufferzone_w'@'localhost' IDENTIFIED BY '5slDhzFwY28C';
GRANT SELECT ON wp_pb_beta_bufferzone.* TO 'bt_bufferzone_r'@'localhost' IDENTIFIED BY 'kRG22BZUnwWw';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_bufferzone`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE on pb_mostcraved.* to 'pb_spx_mc_w'@'localhost' identified by '9LU3vESWgx';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON pb_mostcraved.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_idlyitw.* TO 'idlyitw_w'@'localhost' IDENTIFIED BY 'Qf8nut726RbZ';
GRANT SELECT ON wp_pb_idlyitw.* TO 'idlyitw_r'@'localhost' IDENTIFIED BY '5UaS26F34Zh2';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_idlyitw`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

GRANT SELECT, INSERT, UPDATE, DELETE ON wp_pb_beta_idlyitw.* TO 'bt_idlyitw_w'@'localhost' IDENTIFIED BY '2d58w9kaB6C8';
GRANT SELECT ON wp_pb_beta_idlyitw.* TO 'bt_idlyitw_r'@'localhost' IDENTIFIED BY 'q42C6YrtXp9c';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beta_idlyitw`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_totallyher` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_totallyher`.* TO 'totallyher_w'@'localhost' IDENTIFIED BY 'yZfDmGRF9VAM';
GRANT SELECT ON `wp_pb_totallyher`.* TO 'totallyher_r'@'localhost' IDENTIFIED BY 'yEP6zoQ6bCy6';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_totallyher`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_totallyher`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_totallyher`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_totallyher` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_totallyher`.* TO 'bt_totallyher_w'@'localhost' IDENTIFIED BY 'j9sLoJpgzdcp';
GRANT SELECT ON `wp_pb_beta_totallyher`.* TO 'bt_totallyher_r'@'localhost' IDENTIFIED BY 'lbFD4nw2HhKE';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_totallyher`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_totallyher`.* TO 'pb_meta_r'@'localhost';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_wholesomebabyfood` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_wholesomebabyfood`.* TO 'wholesomebabyf_w'@'localhost' IDENTIFIED BY 'KMHnn3rEFK4u';
GRANT SELECT ON `wp_pb_wholesomebabyfood`.* TO 'wholesomebabyf_r'@'localhost' IDENTIFIED BY 'yAD9rRA3nKI9';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_wholesomebabyfood`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_wholesomebabyfood`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_wholesomebabyfood`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_wholesomebabyfood` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_wholesomebabyfood`.* TO 'bt_wholesomeba_w'@'localhost' IDENTIFIED BY 'NHT9t1pya8wD';
GRANT SELECT ON `wp_pb_beta_wholesomebabyfood`.* TO 'bt_wholesomeba_r'@'localhost' IDENTIFIED BY 'yIWKHI1H0QUf';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_wholesomebabyfood`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_wholesomebabyfood`.* TO 'pb_meta_r'@'localhost';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_hoopsvibe` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_hoopsvibe`.* TO 'hoopsvibe_w'@'localhost' IDENTIFIED BY 'EbNy0rIAQwHh';
GRANT SELECT ON `wp_pb_hoopsvibe`.* TO 'hoopsvibe_r'@'localhost' IDENTIFIED BY 'PdAHy8I9uneA';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_hoopsvibe`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_hoopsvibe`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_hoopsvibe`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_hoopsvibe` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_hoopsvibe`.* TO 'bt_hoopsvibe_w'@'localhost' IDENTIFIED BY 'hKLtk9SaJyO8';
GRANT SELECT ON `wp_pb_beta_hoopsvibe`.* TO 'bt_hoopsvibe_r'@'localhost' IDENTIFIED BY 'PDojadMCC7F2';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_hoopsvibe`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_hoopsvibe`.* TO 'pb_meta_r'@'localhost';

/* token */

/* mandatory SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_mandatory` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_mandatory`.* TO 'mandatory_w'@'localhost' IDENTIFIED BY 'E2LzKSlqeO2D';
GRANT SELECT ON `wp_pb_mandatory`.* TO 'mandatory_r'@'localhost' IDENTIFIED BY 'KQRsiU4jp4eX';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_mandatory`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_mandatory`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_mandatory`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* mandatory SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_mandatory` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_mandatory`.* TO 'bt_mandatory_w'@'localhost' IDENTIFIED BY '1XVqwscXoMkc';
GRANT SELECT ON `wp_pb_beta_mandatory`.* TO 'bt_mandatory_r'@'localhost' IDENTIFIED BY 'LnM6rUsRXMiZ';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_mandatory`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_mandatory`.* TO 'pb_meta_r'@'localhost';

/* awards_totalbeauty SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_awards_totalbeauty` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_awards_totalbeauty`.* TO 'awards_totalbe_w'@'localhost' IDENTIFIED BY 'wX96IbXD2a9u';
GRANT SELECT ON `wp_pb_awards_totalbeauty`.* TO 'awards_totalbe_r'@'localhost' IDENTIFIED BY 'rBQKkZBfgM5Z';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_awards_totalbeauty`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_awards_totalbeauty`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_awards_totalbeauty`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* awards_totalbeauty SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_awards_totalbeauty` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_awards_totalbeauty`.* TO 'bt_awards_tota_w'@'localhost' IDENTIFIED BY 'g73J88QpTINk';
GRANT SELECT ON `wp_pb_beta_awards_totalbeauty`.* TO 'bt_awards_tota_r'@'localhost' IDENTIFIED BY 'aHGXeZXlS4yp';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_awards_totalbeauty`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_awards_totalbeauty`.* TO 'pb_meta_r'@'localhost';

/* studio_musicfeeds SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_studio_musicfeeds` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_studio_musicfeeds`.* TO 'studio_musicfe_w'@'localhost' IDENTIFIED BY 'jDPEfN7h1wWm';
GRANT SELECT ON `wp_pb_studio_musicfeeds`.* TO 'studio_musicfe_r'@'localhost' IDENTIFIED BY 'nXzuGEJVBp2D';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_studio_musicfeeds`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_studio_musicfeeds`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_studio_musicfeeds`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* studio_musicfeeds SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_studio_musicfeeds` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_studio_musicfeeds`.* TO 'bt_studio_musi_w'@'localhost' IDENTIFIED BY 'FYMBzZItBpHZ';
GRANT SELECT ON `wp_pb_beta_studio_musicfeeds`.* TO 'bt_studio_musi_r'@'localhost' IDENTIFIED BY 'BniY2t02NYMh';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_studio_musicfeeds`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_studio_musicfeeds`.* TO 'pb_meta_r'@'localhost';

/* ropeofsilicon SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_ropeofsilicon` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_ropeofsilicon`.* TO 'ropeofsilicon_w'@'localhost' IDENTIFIED BY '4rWVsBxSKCO4';
GRANT SELECT ON `wp_pb_ropeofsilicon`.* TO 'ropeofsilicon_r'@'localhost' IDENTIFIED BY 'tIuMTubvjJfm';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_ropeofsilicon`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_ropeofsilicon`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_ropeofsilicon`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* ropeofsilicon SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_ropeofsilicon` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_ropeofsilicon`.* TO 'bt_ropeofsilic_w'@'localhost' IDENTIFIED BY 'B7KG6vUcbqVf';
GRANT SELECT ON `wp_pb_beta_ropeofsilicon`.* TO 'bt_ropeofsilic_r'@'localhost' IDENTIFIED BY 'k0BZCRYWgjFK';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_ropeofsilicon`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_ropeofsilicon`.* TO 'pb_meta_r'@'localhost';

/* dogtime SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_dogtime` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_dogtime`.* TO 'dogtime_w'@'localhost' IDENTIFIED BY 'V1pJKb8BSI3I';
GRANT SELECT ON `wp_pb_dogtime`.* TO 'dogtime_r'@'localhost' IDENTIFIED BY '0edaZGOh32oD';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_dogtime`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_dogtime`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_dogtime`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* dogtime SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_dogtime` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_dogtime`.* TO 'bt_dogtime_w'@'localhost' IDENTIFIED BY 'SIBD5IacGBnW';
GRANT SELECT ON `wp_pb_beta_dogtime`.* TO 'bt_dogtime_r'@'localhost' IDENTIFIED BY '47ejm3gM1qb4';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_dogtime`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_dogtime`.* TO 'pb_meta_r'@'localhost';

/* base SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_base` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_base`.* TO 'base_w'@'localhost' IDENTIFIED BY 'Z6MAjzkqFTHb';
GRANT SELECT ON `wp_pb_base`.* TO 'base_r'@'localhost' IDENTIFIED BY 'HEeD2oiItn5H';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_base`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_base`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_base`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* base SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_base` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_base`.* TO 'bt_base_w'@'localhost' IDENTIFIED BY 'iCuYSVmLg4Mr';
GRANT SELECT ON `wp_pb_beta_base`.* TO 'bt_base_r'@'localhost' IDENTIFIED BY 'Na1njp86qXjP';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_base`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_base`.* TO 'pb_meta_r'@'localhost';

/* musicfeeds SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_musicfeeds` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_musicfeeds`.* TO 'musicfeeds_w'@'localhost' IDENTIFIED BY 'WfuydrZivv3x';
GRANT SELECT ON `wp_pb_musicfeeds`.* TO 'musicfeeds_r'@'localhost' IDENTIFIED BY 'eWJvWy3eEVaF';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_musicfeeds`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_musicfeeds`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_musicfeeds`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* musicfeeds SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_musicfeeds` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_musicfeeds`.* TO 'bt_musicfeeds_w'@'localhost' IDENTIFIED BY '7WspcA0vWgGf';
GRANT SELECT ON `wp_pb_beta_musicfeeds`.* TO 'bt_musicfeeds_r'@'localhost' IDENTIFIED BY 'ZaTlClItWIpH';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_musicfeeds`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_musicfeeds`.* TO 'pb_meta_r'@'localhost';

/* cattime SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_cattime` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_cattime`.* TO 'cattime_w'@'localhost' IDENTIFIED BY 'aALy1SvSUCIt';
GRANT SELECT ON `wp_pb_cattime`.* TO 'cattime_r'@'localhost' IDENTIFIED BY 'obR9lUPrq1sD';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_cattime`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_cattime`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_cattime`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* cattime SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_cattime` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_cattime`.* TO 'bt_cattime_w'@'localhost' IDENTIFIED BY 'gXfyhfLtIZtm';
GRANT SELECT ON `wp_pb_beta_cattime`.* TO 'bt_cattime_r'@'localhost' IDENTIFIED BY 'zofVFNocKU3N';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_cattime`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_cattime`.* TO 'pb_meta_r'@'localhost';

/* evolvemediallc SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_evolvemediallc` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_evolvemediallc`.* TO 'evolvemediallc_w'@'localhost' IDENTIFIED BY 'tWG9zyxRRQtH';
GRANT SELECT ON `wp_pb_evolvemediallc`.* TO 'evolvemediallc_r'@'localhost' IDENTIFIED BY 'b6sWZ28VLFF2';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_evolvemediallc`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_evolvemediallc`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_evolvemediallc`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* evolvemediallc SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_evolvemediallc` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_evolvemediallc`.* TO 'bt_evolvemedia_w'@'localhost' IDENTIFIED BY 'xuCo9Z5ysACm';
GRANT SELECT ON `wp_pb_beta_evolvemediallc`.* TO 'bt_evolvemedia_r'@'localhost' IDENTIFIED BY 'AAYw9z4BJ0wC';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_evolvemediallc`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_evolvemediallc`.* TO 'pb_meta_r'@'localhost';

/* beautyriot SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beautyriot` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beautyriot`.* TO 'beautyriot_w'@'localhost' IDENTIFIED BY 'ULfTwYJF6pEn';
GRANT SELECT ON `wp_pb_beautyriot`.* TO 'beautyriot_r'@'localhost' IDENTIFIED BY 'yZvQ94Go5oUA';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beautyriot`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beautyriot`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_beautyriot`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* beautyriot SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_beautyriot` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_beautyriot`.* TO 'bt_beautyriot_w'@'localhost' IDENTIFIED BY 'gOyL7GRXxGGA';
GRANT SELECT ON `wp_pb_beta_beautyriot`.* TO 'bt_beautyriot_r'@'localhost' IDENTIFIED BY '8FHC62Gy41NU';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_beautyriot`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_beautyriot`.* TO 'pb_meta_r'@'localhost';

/* totallykidz SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_totallykidz` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_totallykidz`.* TO 'totallykidz_w'@'localhost' IDENTIFIED BY '5Wyd11p3oyIE';
GRANT SELECT ON `wp_pb_totallykidz`.* TO 'totallykidz_r'@'localhost' IDENTIFIED BY 'XgS5ojQdIzrD';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_totallykidz`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_totallykidz`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_totallykidz`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* totallykidz SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_totallykidz` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_totallykidz`.* TO 'bt_totallykidz_w'@'localhost' IDENTIFIED BY 'kF0Z7oFQycFw';
GRANT SELECT ON `wp_pb_beta_totallykidz`.* TO 'bt_totallykidz_r'@'localhost' IDENTIFIED BY 'O1K9ph11GB6J';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_totallykidz`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_totallykidz`.* TO 'pb_meta_r'@'localhost';

/* afterellen SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_afterellen` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_afterellen`.* TO 'afterellen_w'@'localhost' IDENTIFIED BY '7IYfisvvFfJt';
GRANT SELECT ON `wp_pb_afterellen`.* TO 'afterellen_r'@'localhost' IDENTIFIED BY 'p9Q941gAGHwy';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_afterellen`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_afterellen`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_afterellen`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* afterellen SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_afterellen` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_afterellen`.* TO 'bt_afterellen_w'@'localhost' IDENTIFIED BY 'nBDuQ9mj20Ax';
GRANT SELECT ON `wp_pb_beta_afterellen`.* TO 'bt_afterellen_r'@'localhost' IDENTIFIED BY 'FQ8Tq0PfekkY';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_afterellen`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_afterellen`.* TO 'pb_meta_r'@'localhost';

/* springboard SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_springboard` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_springboard`.* TO 'springboard_w'@'localhost' IDENTIFIED BY 'A034Xk1hPyE8';
GRANT SELECT ON `wp_pb_springboard`.* TO 'springboard_r'@'localhost' IDENTIFIED BY 'EuOgkTWPD4HW';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_springboard`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_springboard`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_springboard`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* springboard SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_springboard` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_springboard`.* TO 'bt_springboard_w'@'localhost' IDENTIFIED BY 'jVe2HJHgboQ7';
GRANT SELECT ON `wp_pb_beta_springboard`.* TO 'bt_springboard_r'@'localhost' IDENTIFIED BY 'hkd4aI2KXF25';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_springboard`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_springboard`.* TO 'pb_meta_r'@'localhost';

/* totallyhermedia SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_totallyhermedia` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_totallyhermedia`.* TO 'totallyhermedi_w'@'localhost' IDENTIFIED BY 'EFSt6NSKH1ih';
GRANT SELECT ON `wp_pb_totallyhermedia`.* TO 'totallyhermedi_r'@'localhost' IDENTIFIED BY 'K1WAIndTP1rE';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_totallyhermedia`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_totallyhermedia`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_totallyhermedia`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* totallyhermedia SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_totallyhermedia` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_totallyhermedia`.* TO 'bt_totallyherm_w'@'localhost' IDENTIFIED BY 'hpr8tVgtDtE0';
GRANT SELECT ON `wp_pb_beta_totallyhermedia`.* TO 'bt_totallyherm_r'@'localhost' IDENTIFIED BY '21xmIvtXajB1';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_totallyhermedia`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_totallyhermedia`.* TO 'pb_meta_r'@'localhost';

/* craveonlinemedia SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_craveonlinemedia` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_craveonlinemedia`.* TO 'craveonlinemed_w'@'localhost' IDENTIFIED BY '1yquNy9pIQE2';
GRANT SELECT ON `wp_pb_craveonlinemedia`.* TO 'craveonlinemed_r'@'localhost' IDENTIFIED BY 'twchkUTUcwOY';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_craveonlinemedia`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_craveonlinemedia`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_craveonlinemedia`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* craveonlinemedia SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_craveonlinemedia` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_craveonlinemedia`.* TO 'bt_craveonline_w'@'localhost' IDENTIFIED BY 'KwCAQxOMcS7H';
GRANT SELECT ON `wp_pb_beta_craveonlinemedia`.* TO 'bt_craveonline_r'@'localhost' IDENTIFIED BY '4ei8eVensQN3';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_craveonlinemedia`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_craveonlinemedia`.* TO 'pb_meta_r'@'localhost';

/* webecoist SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_webecoist` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_webecoist`.* TO 'webecoist_w'@'localhost' IDENTIFIED BY 'zHhg9h5iNMiT';
GRANT SELECT ON `wp_pb_webecoist`.* TO 'webecoist_r'@'localhost' IDENTIFIED BY 'IlvrSKCVYZYs';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_webecoist`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_webecoist`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_webecoist`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* webecoist SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_webecoist` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_webecoist`.* TO 'bt_webecoist_w'@'localhost' IDENTIFIED BY 'IpFhsLtxSRwS';
GRANT SELECT ON `wp_pb_beta_webecoist`.* TO 'bt_webecoist_r'@'localhost' IDENTIFIED BY 'Smn3bk1E6dJV';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_webecoist`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_webecoist`.* TO 'pb_meta_r'@'localhost';


/* forums.playstationlifestyle.net SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `forums_psl` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DROP, DELETE ON `forums_psl`.* TO 'forums_psl_w'@'localhost' IDENTIFIED BY 'CsePomLIp9GU';
GRANT SELECT ON `forums_psl`.* TO 'forums_psl_r'@'localhost' IDENTIFIED BY 'eVQUTjXuR3lf';

/* forums.sherdog.com (xenforo) SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `forums_sdc` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `forums_sdc`.* TO 'forums_sdc_w'@'localhost' IDENTIFIED BY 'vq5bwWhNLetZ';
GRANT SELECT ON `forums_sdc`.* TO 'forums_sdc_r'@'localhost' IDENTIFIED BY 'OSBjQ2Mgdzd9';

/* forums.afterellen.com (xenforo) SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `forums_ae` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `forums_ae`.* TO 'forums_ae_w'@'localhost' IDENTIFIED BY '8kZ93Jp24QZe';
GRANT SELECT ON `forums_ae`.* TO 'forums_ae_r'@'localhost' IDENTIFIED BY '69y5K378Ez29';

/* hboards.hockeysfuture.com (xenforo) SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `forums_hfb` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `forums_hfb`.* TO 'forums_hfb_w'@'localhost' IDENTIFIED BY 'a6dqRjciPIY5';
GRANT SELECT ON `forums_hfb`.* TO 'forums_hfb_r'@'localhost' IDENTIFIED BY 'llV9Vt8BGc6V';

/* forums.wrestlezone.com (xenforo) SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `forums_wz` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `forums_wz`.* TO 'forums_wz_w'@'localhost' IDENTIFIED BY 'R61Cw07dhQBE';
GRANT SELECT ON `forums_wz`.* TO 'forums_wz_r'@'localhost' IDENTIFIED BY 'iWqjjisq19oE';

/* comingsoon SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_comingsoon` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_comingsoon`.* TO 'comingsoon_w'@'localhost' IDENTIFIED BY 'ubRypH2YBkMJ';
GRANT SELECT ON `wp_pb_comingsoon`.* TO 'comingsoon_r'@'localhost' IDENTIFIED BY 'p0fc9O71MrNL';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_comingsoon`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_comingsoon`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_comingsoon`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* comingsoon SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_comingsoon` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_comingsoon`.* TO 'bt_comingsoon_w'@'localhost' IDENTIFIED BY 'KR9I6DcercEC';
GRANT SELECT ON `wp_pb_beta_comingsoon`.* TO 'bt_comingsoon_r'@'localhost' IDENTIFIED BY '3JTrXKcMxmQq';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_comingsoon`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_comingsoon`.* TO 'pb_meta_r'@'localhost';

/* ringtv SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_ringtv` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_ringtv`.* TO 'ringtv_w'@'localhost' IDENTIFIED BY 'qW2bwmdWnmNg';
GRANT SELECT ON `wp_pb_ringtv`.* TO 'ringtv_r'@'localhost' IDENTIFIED BY 'SznUTtfDWReR';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_ringtv`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_ringtv`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_ringtv`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* ringtv SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_ringtv` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_ringtv`.* TO 'bt_ringtv_w'@'localhost' IDENTIFIED BY '1iEQ23PU0Myf';
GRANT SELECT ON `wp_pb_beta_ringtv`.* TO 'bt_ringtv_r'@'localhost' IDENTIFIED BY 'dLPchTol48Z1';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_ringtv`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_ringtv`.* TO 'pb_meta_r'@'localhost';

/* superherohype SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_superherohype` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_superherohype`.* TO 'superherohype_w'@'localhost' IDENTIFIED BY 'QkS7cWBiBI2Z';
GRANT SELECT ON `wp_pb_superherohype`.* TO 'superherohype_r'@'localhost' IDENTIFIED BY 'qKn0yH6kXcGP';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_superherohype`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_superherohype`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_superherohype`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* superherohype SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_superherohype` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_superherohype`.* TO 'bt_superherohy_w'@'localhost' IDENTIFIED BY 'xBDVELtJ9IaB';
GRANT SELECT ON `wp_pb_beta_superherohype`.* TO 'bt_superherohy_r'@'localhost' IDENTIFIED BY 'VVyeTxuVuKxv';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_superherohype`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_superherohype`.* TO 'pb_meta_r'@'localhost';

/* shocktillyoudrop SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_shocktillyoudrop` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_shocktillyoudrop`.* TO 'shocktillyoudr_w'@'localhost' IDENTIFIED BY 'fZ2DG8iQjojt';
GRANT SELECT ON `wp_pb_shocktillyoudrop`.* TO 'shocktillyoudr_r'@'localhost' IDENTIFIED BY '7wQ9yMtBkO6i';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_shocktillyoudrop`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_shocktillyoudrop`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_shocktillyoudrop`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* shocktillyoudrop SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_shocktillyoudrop` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_shocktillyoudrop`.* TO 'bt_shocktillyo_w'@'localhost' IDENTIFIED BY 'OsVO6ZSXRMli';
GRANT SELECT ON `wp_pb_beta_shocktillyoudrop`.* TO 'bt_shocktillyo_r'@'localhost' IDENTIFIED BY 'Px9HEQezmvML';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_shocktillyoudrop`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_shocktillyoudrop`.* TO 'pb_meta_r'@'localhost';

/* SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_momtastic` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_momtastic`.* TO 'momtastic_w'@'localhost' IDENTIFIED BY 'U44d6tgJgIsj';
GRANT SELECT ON `wp_pb_momtastic`.* TO 'momtastic_r'@'localhost' IDENTIFIED BY 'jCamMqTHsFbC';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_momtastic`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_momtastic`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_momtastic`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_momtastic` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_momtastic`.* TO 'bt_momtastic_w'@'localhost' IDENTIFIED BY 'QdgZ62B5uciJ';
GRANT SELECT ON `wp_pb_beta_momtastic`.* TO 'bt_momtastic_r'@'localhost' IDENTIFIED BY '2jkUm3uc4X1U';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_momtastic`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_momtastic`.* TO 'pb_meta_r'@'localhost';


/* mumtasticuk SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_mumtasticuk` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_mumtasticuk`.* TO 'mumtasticuk_w'@'localhost' IDENTIFIED BY 'SoQmLXzbx2c7';
GRANT SELECT ON `wp_pb_mumtasticuk`.* TO 'mumtasticuk_r'@'localhost' IDENTIFIED BY 'soup6gjVR07i';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_mumtasticuk`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_mumtasticuk`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_mumtasticuk`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* mumtasticuk SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_mumtasticuk` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_mumtasticuk`.* TO 'bt_mumtasticuk_w'@'localhost' IDENTIFIED BY 'O1cezM7SbfV2';
GRANT SELECT ON `wp_pb_beta_mumtasticuk`.* TO 'bt_mumtasticuk_r'@'localhost' IDENTIFIED BY 'cnM7ni3RL61d';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_mumtasticuk`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_mumtasticuk`.* TO 'pb_meta_r'@'localhost';

/* momtasticau SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_momtasticau` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_momtasticau`.* TO 'momtasticau_w'@'localhost' IDENTIFIED BY 'dVqW8dudytWz';
GRANT SELECT ON `wp_pb_momtasticau`.* TO 'momtasticau_r'@'localhost' IDENTIFIED BY 'xo6R7nzlPLCU';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_momtasticau`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_momtasticau`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_momtasticau`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* momtasticau SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_momtasticau` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_momtasticau`.* TO 'bt_momtasticau_w'@'localhost' IDENTIFIED BY 'ab0NHM4E81gw';
GRANT SELECT ON `wp_pb_beta_momtasticau`.* TO 'bt_momtasticau_r'@'localhost' IDENTIFIED BY 'NeZgRnXBW0eo';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_momtasticau`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_momtasticau`.* TO 'pb_meta_r'@'localhost';

/* wrestlezone SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_wrestlezone` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_wrestlezone`.* TO 'wrestlezone_w'@'localhost' IDENTIFIED BY 'Gcak6uHTLRki';
GRANT SELECT ON `wp_pb_wrestlezone`.* TO 'wrestlezone_r'@'localhost' IDENTIFIED BY 'rxKc912D8hqt';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_wrestlezone`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_wrestlezone`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_wrestlezone`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* wrestlezone SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_wrestlezone` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_wrestlezone`.* TO 'bt_wrestlezone_w'@'localhost' IDENTIFIED BY '7Oeo3rifVzJw';
GRANT SELECT ON `wp_pb_beta_wrestlezone`.* TO 'bt_wrestlezone_r'@'localhost' IDENTIFIED BY 'Vx8jTMv69N4N';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_wrestlezone`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_wrestlezone`.* TO 'pb_meta_r'@'localhost';

/* liveoutdoors SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_liveoutdoors` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_liveoutdoors`.* TO 'liveoutdoors_w'@'localhost' IDENTIFIED BY 'LJsJrjwI0zwy';
GRANT SELECT ON `wp_pb_liveoutdoors`.* TO 'liveoutdoors_r'@'localhost' IDENTIFIED BY 'GsDqBEGeX4vt';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_liveoutdoors`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_liveoutdoors`.* TO 'pb_meta_r'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE ON `wp_pb_liveoutdoors`.* TO 'ruckus'@'localhost' IDENTIFIED BY '3S4a256Gp3';

/* liveoutdoors SBB */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wp_pb_beta_liveoutdoors` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_liveoutdoors`.* TO 'bt_liveoutdoor_w'@'localhost' IDENTIFIED BY 'I8EOmMSyLLGL';
GRANT SELECT ON `wp_pb_beta_liveoutdoors`.* TO 'bt_liveoutdoor_r'@'localhost' IDENTIFIED BY 'qgF3AoJkYbfu';
GRANT SELECT, INSERT, UPDATE, DELETE ON `wp_pb_beta_liveoutdoors`.* TO 'pb_meta_w'@'localhost';
GRANT SELECT ON `wp_pb_beta_liveoutdoors`.* TO 'pb_meta_r'@'localhost';


/* api.comingsoon.net SBX */
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `csmovies` /*!40100 DEFAULT CHARACTER SET utf8 */;
GRANT SELECT, INSERT, UPDATE, DELETE ON `csmovies`.* TO 'csmovies_w'@'localhost' IDENTIFIED BY 'YZxAPbwhGihJ';
GRANT SELECT ON `csmovies`.* TO 'csmovies_r'@'localhost' IDENTIFIED BY 'gxJ6Z4C5UlLs';


GRANT SELECT ON *.* TO 'dbsync_r'@'app1v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'rTs59W38T6';
GRANT CREATE, DROP, REFERENCES, LOCK TABLES, ALTER, SELECT, INSERT ON *.* TO 'dbsync_w'@'app1v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'TS5K92J8X7';

GRANT SELECT ON *.* TO 'dbsync_r'@'app2v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'rTs59W38T6';
GRANT CREATE, DROP, REFERENCES, LOCK TABLES, ALTER, SELECT, INSERT ON *.* TO 'dbsync_w'@'app2v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'TS5K92J8X7';

GRANT SELECT ON *.* TO 'dbsync_r'@'app1v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'rTs59W38T6'; 
GRANT CREATE, DROP, REFERENCES, LOCK TABLES, ALTER, SELECT, INSERT ON *.* TO 'dbsync_w'@'app1v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'TS5K92J8X7';

GRANT SELECT ON *.* TO 'dbsync_r'@'app2v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'rTs59W38T6';
GRANT CREATE, DROP, REFERENCES, LOCK TABLES, ALTER, SELECT, INSERT ON *.* TO 'dbsync_w'@'app2v-cap.tp.prd.lax.gnmedia.net' IDENTIFIED BY 'TS5K92J8X7';

GRANT SELECT ON *.* TO 'dbsync_r'@'10.11.20.82' IDENTIFIED BY 'rTs59W38T6';
GRANT CREATE, DROP, REFERENCES, LOCK TABLES, ALTER, SELECT, INSERT ON *.* TO 'dbsync_w'@'10.11.20.82' IDENTIFIED BY 'TS5K92J8X7';

GRANT SELECT ON *.* TO 'dbsync_r'@'10.11.20.90' IDENTIFIED BY 'rTs59W38T6';
GRANT CREATE, DROP, REFERENCES, LOCK TABLES, ALTER, SELECT, INSERT ON *.* TO 'dbsync_w'@'10.11.20.90' IDENTIFIED BY 'TS5K92J8X7';

GRANT SELECT, REPLICATION CLIENT ON *.* TO 'monitor'@'app%v-nagios.tp.%.lax.gnmedia.net' IDENTIFIED BY PASSWORD '*405A4A5538F04C10853378C139B4FE769DE0A42F';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('temp123');
GRANT ALL PRIVILEGES ON *.* TO 'mdillon'@'localhost' IDENTIFIED BY 'temp123' WITH GRANT OPTION; 

flush privileges;

