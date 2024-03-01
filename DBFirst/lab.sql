\gset
DROP TABLE IF EXISTS monolit, stars, humanity, repeater, signals, rest;


CREATE TABLE monolit(
    id SERIAL PRIMARY KEY,
    monolit_name VARCHAR(256),
    condition_of_monolit VARCHAR(256),
    time_of_signal VARCHAR(32) NOT NULL
);


CREATE TABLE signals(
    id SERIAL PRIMARY KEY,
    signal_name VARCHAR(256),
    monolit_id int NOT NULL REFERENCES monolit(id),
    direction VARCHAR(256),
    time_of_send VARCHAR(32) NOT NULL
);


CREATE TABLE repeater(
    id SERIAL PRIMARY KEY,
    repeater_name VARCHAR(256),
    signal_id int REFERENCES signals(id),
    surface VARCHAR(256),
    time_of_broadcast VARCHAR(32)
);


CREATE TABLE stars(
    id SERIAL PRIMARY KEY,
    stars_name VARCHAR(256),
    signal_id int REFERENCES signals(id),
    repeater_id int REFERENCES repeater(id),
    time_of_signal_arrival VARCHAR(256),
    surface VARCHAR(256)
);


CREATE TABLE rest(
    id SERIAL PRIMARY KEY,
    rest_name VARCHAR(256),
    stars_id int REFERENCES stars(id),
    duration VARCHAR(256),
    reason VARCHAR(256)
);


CREATE TABLE humanity(
    id SERIAL PRIMARY KEY,
    rest_id int REFERENCES rest(id),
    humanity_name VARCHAR(256),
    time_of_signal_reception VARCHAR(256)
);


INSERT INTO monolit (monolit_name, condition_of_monolit, time_of_signal) VALUES 
('монолит ЛМА-1', 'включен', '10:12:2023 23:59:43');


INSERT INTO signals (signal_name, monolit_id, direction, time_of_send)
VALUES
('сигнал', 1, 'куда-то к звездам', '22:12:2023 12:43:32'),
('сигнал', 1, 'куда-то к звездам', '22:12:2023 13:43:32');


INSERT INTO repeater (repeater_name, signal_id, surface, time_of_broadcast)
VALUES
('ретрансляционное устройство', 1, 'где-то близ Сатурна', 'долгие годы');


INSERT INTO stars (stars_name, signal_id, repeater_id, time_of_signal_arrival, surface)
VALUES
('звезды', 1, 1, 'долгие годы', 'в далекой далекой галактике'),
('звезды', 2, NULL, 'долгие годы', 'в далекой далекой галактике');


INSERT INTO rest (stars_id, rest_name, duration, reason)
VALUES
(1, 'передышка', 'десятки, а вернее всего сотни лет', 'большое расстояние до звезд');


INSERT INTO humanity (rest_id, humanity_name, time_of_signal_reception)
VALUES
(1, 'человечество', 'десятки, а вернее всего сотни лет');
