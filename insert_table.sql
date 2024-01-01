COPY passenger FROM 'E:\railway_project_database_sql\data\passenger.txt' WITH DELIMITER E'\t';
COPY train FROM 'E:\railway_project_database_sql\data\train.txt' WITH DELIMITER E',';

------------------------------

INSERT INTO station(station_id, station_name, city) VALUES
('HAN' , 'Ha Noi' , 'Ha Noi'),
('LOB' , 'Long Bien' , 'Ha Noi'),
('GLA' , 'Gia Lam' , 'Ha Noi'),
('HAD' , 'Hai Duong' , 'Hai Duong'),
('HAP' , 'Hai Phong', ' Hai Phong'),
('PUT' , 'Phu Tho' , 'Phu Tho'),
('YEB' , 'Yen Bai' , 'Yen Bai'),
('LAC' , 'Lao Cai' , 'Lao Cai'),
('NAD' , 'Nam Dinh' , 'Nam Dinh'),
('NIB' , 'Ninh Binh' , 'Ninh Binh'),
('THA' , 'Thanh Hoa' , 'Thanh Hoa'),
('VIN' , 'Vinh' , 'Nghe An'),
('DOH' , 'Dong Hoi' , 'Quang Binh'),
('HUE' , 'Hue' , 'Hue'),
('DAN' , 'Da Nang' , 'Da Nang'),
('QNGA' , 'Quang Ngai' , 'Quang Ngai'),
('QNHO' , 'Quy Nhon' , 'Quy Nhon'),
('TUH' , 'Tuy Hoa' , 'Phu Yen'),
('NHT' , 'Nha Trang' , 'Khanh Hoa'),
('PAT' , 'Phan Thiet' , 'Binh Thuạn'),
('BTH' , 'Binh Thuan' , 'Binh Thuan'),
('BHO' , 'Bien Hoa' , 'Dong Nai'),
('SGO' , 'Sai Gon' , 'Sai Gon');

-----------------------------------------

COPY stop FROM 'E:\railway_project_database_sql\data\stop.txt' WITH DELIMITER E',';
COPY train_schedule FROM 'E:\railway_project_database_sql\data\train_schedule2.txt' WITH DELIMITER E'\t';