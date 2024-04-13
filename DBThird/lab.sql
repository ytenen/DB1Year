DROP TABLE IF EXISTS monolit, stars, repeater, signals, rest, MonolitLogger;


CREATE TABLE monolit(
    id SERIAL PRIMARY KEY,
    monolit_name VARCHAR(256) NOT NULL UNIQUE,
    condition_of_monolit VARCHAR(256),
    time_of_signal VARCHAR(32) NOT NULL
);


CREATE TABLE signals(
    id SERIAL PRIMARY KEY ,
    signal_name VARCHAR(256) NOT NULL UNIQUE,
    monolit_id int NOT NULL,
    direction VARCHAR(256),
    time_of_send VARCHAR(32) NOT NULL
);


CREATE TABLE repeater(
    id SERIAL PRIMARY KEY,
    repeater_name VARCHAR(256) NOT NULL UNIQUE,
    signal_id int REFERENCES signals(id),
    surface VARCHAR(256),
    time_of_broadcast VARCHAR(32) NOT NULL,
    FOREIGN KEY(signal_id) REFERENCES signals(id)
);

CREATE TABLE rest(
    id SERIAL PRIMARY KEY ,
    rest_name VARCHAR(256) NOT NULL UNIQUE,
    duration VARCHAR(256),
    reason VARCHAR(256)
);

CREATE TABLE stars(
    id SERIAL PRIMARY KEY,
    stars_name VARCHAR(256) NOT NULL UNIQUE,
    rest_id int REFERENCES rest(id) ON DELETE CASCADE,
    signal_id int REFERENCES signals(id) ON DELETE CASCADE,
    repeater_id int REFERENCES repeater(id) ON DELETE CASCADE,
    time_of_signal_arrival VARCHAR(256) NOT NULL,
    surface VARCHAR(256)
);

CREATE TABLE MonolitLogger(
    id SERIAL PRIMARY KEY,
    update_date DATE
);


CREATE OR REPLACE FUNCTION record_monolit_change()
RETURNS TRIGGER AS $$
BEGIN
  -- Проверим, изменилось ли состояние монолита
  IF OLD.condition_of_monolit <> NEW.condition_of_monolit THEN
    -- Вставим запись в таблицу Rest
    INSERT INTO MonolitLogger (update_date)
    VALUES (CURRENT_DATE);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER monolit_after_update
BEFORE UPDATE OR INSERT ON monolit
FOR EACH ROW
EXECUTE FUNCTION record_monolit_change();

INSERT INTO monolit (monolit_name, condition_of_monolit, time_of_signal) VALUES 
('монолит ЛМА-1', 'включен', '10:12:2023 23:59:43');


INSERT INTO signals (signal_name, monolit_id, direction, time_of_send)
VALUES
('сигнал1', 1, 'куда-то к звездам', '22:12:2023 12:43:32'),
('сигнал2', 1, 'куда-то к звездам', '22:12:2023 13:43:32');


INSERT INTO repeater (repeater_name, signal_id, surface, time_of_broadcast)
VALUES
('ретрансляционное устройство', 1, 'где-то близ Сатурна', 'долгие годы');

INSERT INTO rest (rest_name, duration, reason)
VALUES
('передышка', 'десятки, а вернее всего сотни лет', 'большое расстояние до звезд');


INSERT INTO stars (rest_id, stars_name, signal_id, repeater_id, time_of_signal_arrival, surface)
VALUES
(1, 'звезды1', 1, 1, 'долгие годы', 'в далекой далекой галактике'),
(1, 'звезды2', 2, NULL, 'долгие годы', 'в далекой далекой галактике');

