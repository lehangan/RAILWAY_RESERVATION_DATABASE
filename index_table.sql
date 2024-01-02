CREATE INDEX idx_train_schedule_from_to ON train_schedule(station_from_id, station_to_id);
CREATE INDEX idx_s_trainid_n ON seat using hash(train_id);