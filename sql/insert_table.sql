\COPY passenger FROM '../data/passenger.txt' CSV HEADER DELIMITER ',';
\COPY train FROM '../data/train.txt' CSV HEADER DELIMITER ',';

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

\COPY stop FROM '../data/stop.txt' CSV HEADER DELIMITER ',';
\COPY train_schedule FROM '../data/train_schedule2.txt' CSV HEADER DELIMITER ',';

-- COPY 1000
-- COPY 30
-- INSERT 0 23
-- COPY 248
-- COPY 4879