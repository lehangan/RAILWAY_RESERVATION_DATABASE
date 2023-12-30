COPY passenger FROM 'E:\railway_project_database_sql\data\passenger.txt' WITH DELIMITER E'\t';
COPY train FROM 'E:\railway_project_database_sql\data\train.txt' WITH DELIMITER E',';

------------------------------

INSERT INTO station(station_id, station_name, city) VALUES
('HAN' , 'Ha Noi' , 'Ha Noi'),
('LOB' , 'Long Bien' , 'Ha Noi'),
('GLA' , 'Gia Lam' , 'Ha Noi'),
('HAD' , 'Hai Duong' , 'Hai Duong'),
('HAP' , 'Hai Phong', ' Hai Phong'),
('VIY' , 'Vinh Yen' , 'Vinh Phuc'),
('YEB' , 'Yen Bai' , 'Yen Bai'),
('LAC' , 'Lao Cai' , 'Lao Cai'),
('DAN' , 'Da Nang' , 'Da Nang'),
('THA' , 'Thanh Hoa' , 'Thanh Hoa'),
('DOH' , 'Dong Hoi' , 'Quang Binh'),
('HUE' , 'Hue' , 'Hue'),
('QNGA' , 'Quang Ngai' , 'Quang Ngai'),
('QNHO' , 'Quy Nhon' , 'Quy Nhon'),
('TUH' , 'Tuy Hoa' , 'Phu Yen'),
('NHT' , 'Nha Trang' , 'Khanh Hoa'),
('PTH' , 'Phan Thiet' , 'Binh Thuạn'),
('BTH' , 'Binh Thuan' , 'Binh Thuan'),
('BHO' , 'Bien Hoa' , 'Dong Nai'),
('SGO', 'Sai Gon' , 'Sai Gon')

-----------------------------------------